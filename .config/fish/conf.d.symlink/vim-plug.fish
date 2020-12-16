function vim-plug-install
  vim +"let g:plug_window='enew'" +PlugInstall
end

function vim-plug-update
  vim +"let g:plug_window='enew'" +PlugUpgrade +PlugUpdate
end

function vim-plug-clean
  vim +"let g:plug_window='enew'" +PlugClean
end
