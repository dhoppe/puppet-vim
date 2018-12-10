# == Class: vim::config
#
class vim::config {
  if $::vim::config_dir_source {
    file { 'vim.dir':
      ensure  => $::vim::config_dir_ensure,
      path    => $::vim::config_dir_path,
      force   => $::vim::config_dir_purge,
      purge   => $::vim::config_dir_purge,
      recurse => $::vim::config_dir_recurse,
      source  => $::vim::config_dir_source,
      require => $::vim::config_file_require,
    }
  }

  if $::vim::config_file_path {
    file { 'vim.conf':
      ensure  => $::vim::config_file_ensure,
      path    => $::vim::config_file_path,
      owner   => $::vim::config_file_owner,
      group   => $::vim::config_file_group,
      mode    => $::vim::config_file_mode,
      source  => $::vim::config_file_source,
      content => $::vim::config_file_content,
      require => $::vim::config_file_require,
    }
  }

  if $::vim::default_editor {
    # Fedora/RedHat systems don't have /etc/alternatives/editor out of the box.
    # The below settings match those used in Debian 9
    exec { 'add-editor-alternative':
      path    => '/usr/bin:/usr/sbin/:/bin:/sbin',
      command => "update-alternatives --install /usr/bin/editor editor ${::vim::vim_path} 30",
      unless  => 'test -L /etc/alternatives/editor',
      require => $::vim::config_file_require,
    }

    exec { 'update-alternatives':
      path    => '/usr/bin:/usr/sbin/:/bin:/sbin',
      command => "update-alternatives --set editor ${::vim::vim_path}",
      unless  => "test /etc/alternatives/editor -ef ${::vim::vim_path}",
      require => Exec['add-editor-alternative'],
    }
  }
}
