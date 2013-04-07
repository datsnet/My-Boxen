class people::datsnet {
  # 自分の環境で欲しいresourceをincludeする
  include dropbox
  include skype
  include iterm2::stable #::devもある
  include chrome
  include osx

  # homebrewでインストール
  package {
    [
      'tmux',
      'reattach-to-user-namespace',
      'tig',

    ]:
  }
  package {
  'Kobito':
    source   => "http://kobito.qiita.com/download/Kobito_v1.2.0.zip",
    provider => compressed_app;
  'XtraFinder':
    source   => "http://www.trankynam.com/xtrafinder/downloads/XtraFinder.dmg",
    provider => pkgdmg;
  'zsh':
    install_options => [
      '--disable-etcdir'
    ]
 
  }
 

  $home     = "/Users/${::luser}"
  $src      = "${home}/src"
  $dotfiles = "${src}/dotfiles"

  # ~/src/dotfilesにGitHub上のtaka84u9/dotfilesリポジトリを
  # git-cloneする。そのとき~/srcディレクトリがなければいけない。
  repository { $dotfiles:
    source  => "datsnet/dotfiles",
    require => File[$src]
  }
  # git-cloneしたらインストールする
  exec { "sh ${dotfiles}/install.sh":
    cwd => $dotfiles,
    xcreates => "${home}/.zshrc",
    require => Repository[$dotfiles],
  }
file_line { 'add zsh to /etc/shells':
  path    => '/etc/shells',
  line    => "${boxen::config::homebrewdir}/bin/zsh",
  require => Package['zsh'],
  before  => Osx_chsh[$::luser];
}
osx_chsh { $::luser:
  shell   => "${boxen::config::homebrewdir}/bin/zsh";
}
}
