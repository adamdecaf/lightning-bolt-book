-- Compile-time only. Does not edit upstream spec files.
-- 1. Nest each spec under its chapter (spec H1 becomes H2; inner headings shift).
-- 2. Drop --file-scope path prefixes so chunk URLs stay bolt-08.html, nut-00.html, …
-- 3. Prefix in-spec heading ids with the spec slug so chapter titles are not renamed.
-- 4. Point spec markdown links at the compiled book instead of raw .md files.
-- 5. For BIPs that start at "## Abstract", prepend an H1 from the filename.

local stringify = pandoc.utils.stringify
local in_spec = false
local current_slug = nil
local spec_kind = "nip"

local function strip_filescope(ident)
  if not ident or ident == "" then
    return ident
  end
  return ident:gsub("^.*__", "")
end

local function spec_slug(title)
  local nip = title:match("^NIP%-(%w+)")
  if nip then
    return "nip-" .. nip:lower()
  end
  local nut = title:match("^NUT%-(%w+)")
  if nut then
    return "nut-" .. nut:lower()
  end
  local bolt = title:match("^BOLT #(%d+)")
  if bolt then
    return "bolt-" .. string.format("%02d", tonumber(bolt))
  end
  if title:match("^Extension BOLT") then
    return "bolt-simple-taproot"
  end
  local bip = title:match("^BIP (%d+)")
  if bip then
    return "bip-" .. string.format("%04d", tonumber(bip))
  end
  return nil
end

local function spec_id_from_path(path)
  local file = path:gsub("^[%./]+", ""):gsub("^.*/", "")
  file = file:gsub("%.mediawiki$", ""):gsub("%.md$", "")
  if spec_kind == "bip" then
    local n = file:match("^bip%-?(%d+)$") or file:match("^BIP%-?(%d+)$")
    if n then
      return "bip-" .. string.format("%04d", tonumber(n))
    end
  elseif spec_kind == "bolt" then
    if file == "bolt-simple-taproot" then
      return "bolt-simple-taproot"
    end
    local n = file:match("^(%d+)%-")
    if n then
      return "bolt-" .. n
    end
  elseif spec_kind == "nut" then
    if file:match("^%d+$") then
      return "nut-" .. string.format("%02d", tonumber(file))
    end
  elseif spec_kind == "nip" then
    if file:match("^%x+$") then
      return "nip-" .. file:lower()
    end
  end
  return nil
end

function Meta(meta)
  -- --file-scope reuses this Lua state across files.
  in_spec = false
  current_slug = nil
  if meta["spec-kind"] then
    spec_kind = stringify(meta["spec-kind"])
  end
  return meta
end

local function prepend_bip_title(doc)
  in_spec = false
  current_slug = nil
  if spec_kind ~= "bip" then
    return doc
  end
  local seen = {}
  local blocks = {}
  for _, block in ipairs(doc.blocks) do
    if block.t == "Header" and block.identifier then
      local slug = block.identifier:match("(bip%-%d+)%.md")
      if slug and not seen[slug] then
        seen[slug] = true
        local n = tonumber(slug:match("%d+"))
        table.insert(blocks, pandoc.Header(1, {pandoc.Str("BIP " .. n)}, pandoc.Attr(slug)))
      end
    end
    table.insert(blocks, block)
  end
  doc.blocks = blocks
  return doc
end

local function Header(el)
  local raw_id = el.identifier or ""
  local from_include = raw_id:match("^include__") ~= nil
  local title = stringify(el.content)
  el.identifier = strip_filescope(el.identifier)
  local slug = spec_slug(title)

  if from_include then
    in_spec = false
    current_slug = nil
    return el
  end

  if el.level == 1 and slug then
    in_spec = true
    current_slug = slug
    el.level = 2
    el.identifier = slug
    return el
  elseif in_spec then
    -- Spec files (especially BOLTs) use H1 for inner sections. Keep those
    -- at H3+ so --split-level=2 still yields one page per spec.
    el.level = math.max(el.level + 1, 3)
    if current_slug and el.identifier and el.identifier ~= "" then
      el.identifier = current_slug .. "-" .. el.identifier
    end
    return el
  end
  return el
end

local function spec_md_target(target)
  if target:match("^https?://") then
    return nil, nil
  end
  local path, frag = target:match("^(.-)%.md(#.+)$")
  if not path then
    path, frag = target:match("^(.-)%.mediawiki(#.+)$")
  end
  if not path then
    path = target:match("^(.-)%.md$") or target:match("^(.-)%.mediawiki$")
    frag = ""
  end
  if not path then
    return nil, nil
  end
  return spec_id_from_path(path), frag or ""
end

local function filescope_hash(target)
  local ident = target:match("^#(.*__.*)$")
  if not ident then
    return nil
  end
  local cleaned = ident:gsub("^.*__", ""):lower()
  local fname = ident:match("^%w+__(.+)%.md__") or ident:match("^%w+__(.+)%.mediawiki__")
  if fname then
    local id = spec_id_from_path(fname)
    if id then
      if cleaned == id then
        return "#" .. id
      end
      return "#" .. id .. "-" .. cleaned
    end
  end
  return "#" .. cleaned
end

local function Link(el)
  local id, frag = spec_md_target(el.target)
  if id then
    if FORMAT == "chunkedhtml" then
      if frag ~= "" then
        el.target = id .. ".html#" .. id .. "-" .. frag:sub(2)
      else
        el.target = id .. ".html"
      end
    elseif frag ~= "" then
      el.target = "#" .. id .. "-" .. frag:sub(2)
    else
      el.target = "#" .. id
    end
    return el
  end
  local rewritten = filescope_hash(el.target)
  if rewritten then
    el.target = rewritten
  end
  return el
end

return {
  { Meta = Meta, Pandoc = prepend_bip_title },
  { Header = Header, Link = Link },
}
