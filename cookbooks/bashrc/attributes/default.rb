#
# Cookbook Name:: bashrc
# Attributes:: default
#
# Copyright 2011, Fletcher Nichol
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['bashrc']['update']       = false
default['bashrc']['user_update']  = false

default['bashrc']['installer_url']  =
  "https://raw.github.com/fnichol/bashrc/master/contrib/install-system-wide"
default['bashrc']['user_installer_url']  =
  "https://raw.github.com/fnichol/bashrc/master/contrib/install-local"

case platform
when "ubuntu", "debian", "suse"
  node.set['bashrc']['user_home_root']  = "/home"
when "mac_os_x"
  node.set['bashrc']['user_home_root']  = "/Users"
end
