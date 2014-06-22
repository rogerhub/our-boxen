class people::rogerhub {
  include chrome
  include spotify
  include brewcask

  class { 'fish':
    chsh => true;
  }

  package {
    ['gpgtools', 'macvim', 'keepassx']:
      ensure => installed,
      provider => 'brewcask';
  }

  include osx::dock::autohide
  include osx::no_network_dsstores
  include osx::finder::unhide_library
  include osx::global::expand_save_dialog
  include osx::global::disable_key_press_and_hold
  include osx::global::enable_keyboard_control_access

  include osx::software_update

  class {
    'osx::global::key_repeat_rate':
      rate => 2;
    'osx::global::key_repeat_delay':
      delay => 15;
  }

  $home = "/Users/${::boxen_user}"

  git::config::global {
    'user.name':
      value => 'Roger Chen';
    'user.email':
      value => 'roger@rogerhub.com';
    'push.default':
      value => 'simple';
    'alias.lg':
      value => "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Cre    set %s %Cgreen(%cr)%C(bold blue)<%an>%Creset' --abbrev-commit";
    'alias.dc':
      value => 'diff --cached';
    'alias.dm':
      value => "\"!/bin/bash -c 'git diff $(git merge-base HEAD master) --' __dummy__\"";
    'alias.st':
      value => 'status';
    'alias.co':
      value => 'checkout';
    'alias.up':
      value => "!sh -c 'git pull --prune && git submodule update --init --recursive'";
    'alias.unstage':
      value => 'reset HEAD';
    'color.ui':
      value => 'true';
  }

  repository {
    "${home}/.vim-config":
      source => 'rogerhub/vim-config';
    "${home}/.oh-my-zsh":
      source => 'robbyrussell/oh-my-zsh';
  }

  file {
    "${home}/.vim":
      ensure => "${home}/.vim-config/.vim";
    "${home}/.vimrc":
      ensure => "${home}/.vim-config/.vimrc";
    "${home}/.gvimrc":
      ensure => "${home}/.vim-config/.gvimrc";
    "${home}/.ssh":
      force => true,
      ensure => "${home}/Configuration/ssh";
    "${home}/.zshconfig":
      ensure => "${home}/Configuration/zshconfig";
    "${home}/.config/fish/config.fish":
      ensure => "${home}/Configuration/config.fish";
    "${home}/Local":
      ensure => directory;
  }
}
