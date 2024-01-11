require "../helpers/globals"

g.vimwiki_folding = ''
g.vimwiki_global_ext = 0
g.vimwiki_ext2syntax = {
    ['.md'] = 'markdown',
    ['.markdown'] = 'markdown',
    ['.mdown'] = 'markdown'
}
g.vimwiki_list = {{
    path = '~/vimwiki/',
    auto_tags = 1,
    syntax = 'markdown',
    ext = '.md'
}}

-- to prevent vimwiki override <Tab> behavior
g.vimwiki_key_mappings = {
    all_maps = 1,
    global = 1,
    headers = 1,
    text_objs = 1,
    table_format = 1,
    table_mappings = 1,
    lists = 1,
    links = 0,
    html = 1,
    mouse = 1,
}
-- get back vimwiki's follow link mapping
cmd[[au FileType markdown nnoremap <buffer> <CR> <Plug>VimwikiFollowLink]]