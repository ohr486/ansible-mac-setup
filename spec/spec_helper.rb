require "serverspec"
require "yaml"

set :backend, :exec

# YAMLから設定値を読み込む
def load_configuration(key)
  configuration = YAML.load_file "local.yml"
  packs = configuration[0]["vars"][key] || []
  packs.map do |package|
    package.kind_of?(Hash) ? package["name"] : package
  end
end

# Homebrewパッケージリストを読み込む
def homebrew_packages
  load_configuration "brew_packs"
end
             
# Homebrew Caskパッケージリストを読み込む
def homebrew_cask_packages
  load_configuration "brew_cask_packs"
end

# Caskroomのパスを得る
def homebrew_caskroom
  env = Shellwords.shellsplit(ENV["HOMEBREW_CASK_OPTS"] || "").map do |option|
    option.split("=")
  end
  Hash[*env.flatten]["--caskroom"] || "/opt/homebrew-cask/Caskroom"
end

