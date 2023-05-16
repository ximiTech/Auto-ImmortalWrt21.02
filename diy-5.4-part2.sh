#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

########### 修改默认 IP ###########
# sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate
sed -i 's/192.168.1.1/192.168.1.2/g' package/base-files/files/bin/config_generate

########### 更改大雕源码（可选）###########
# sed -i "s/KERNEL_PATCHVER:=.*/KERNEL_PATCHVER:=5.15/g" target/linux/x86/Makefile

########### 更改dnsmasq的版本 ###########
sed -i "s/PKG_UPSTREAM_VERSION:=.*/PKG_UPSTREAM_VERSION:=2.88/g" package/network/services/dnsmasq/Makefile
sed -i "s/PKG_HASH:=.*/PKG_HASH:=23544deda10340c053bea6f15a93fed6ea7f5aaa85316bfc671ffa6d22fbc1b3/g" package/network/services/dnsmasq/Makefile
sed -i "178i \	$(INSTALL_BIN) ./files/50-dnsmasq-migrate-ipset.sh $(1)/etc/uci-defaults" package/network/services/dnsmasq/Makefile
rm -rf package/network/services/dnsmasq/files
svn co https://github.com/coolsnowwolf/lede/trunk/package/network/services/dnsmasq/files package/network/services/dnsmasq/files/
rm -rf package/network/services/dnsmasq/patches
svn co https://github.com/coolsnowwolf/lede/trunk/package/network/services/dnsmasq/patches package/network/services/dnsmasq/patches/

########### 更改openssl的版本 ###########
rm -rf package/libs/openssl
svn co https://github.com/coolsnowwolf/lede/trunk/package/libs/openssl package/libs/openssl/

########### 维持xray-core的版本 ###########
# sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.7.2/g' feeds/passwall_packages/xray-core/Makefile
# sed -i 's/PKG_RELEASE:=.*/PKG_RELEASE:=1/g' feeds/passwall_packages/xray-core/Makefile
# sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' feeds/passwall_packages/xray-core/Makefile

########### 维持xray-plugin的版本 ###########
# sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.7.2/g' feeds/passwall_packages/xray-plugin/Makefile
# sed -i 's/PKG_RELEASE:=.*/PKG_RELEASE:=1/g' feeds/passwall_packages/xray-plugin/Makefile
# sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' feeds/passwall_packages/xray-plugin/Makefile

cd feeds/packages/net
########### 替换immortal的内置的smartdns版本 ###########
rm -rf smartdns/
svn co https://github.com/coolsnowwolf/packages/trunk/net/smartdns smartdns/
rm -rf smartdns/.svn/
sed -i 's/1.2023.41/1.2023.42/g' smartdns/Makefile
sed -i 's/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=0340d272c3e7a618a5b605d7daf8ab07901ab63a/g' smartdns/Makefile
sed -i 's/PKG_MIRROR_HASH:=.*/PKG_MIRROR_HASH:=skip/g' smartdns/Makefile

########### 替换immortal的内置的openssh版本 ###########
rm -rf openssh/
svn co https://github.com/coolsnowwolf/packages/trunk/net/openssh openssh/
rm -rf openssh/.svn/

cd ../../..

########### 添加immortal的upx包 ###########
cd feeds/packages/utils
rm -rf upx/
svn co https://github.com/immortalwrt/packages/trunk/utils/upx upx/
rm -rf upx/.svn/
cd ../../..
ln -sf ../../../feeds/packages/utils/upx package/feeds/packages/upx

cd feeds/luci/applications
########### 修改immortal的内置的passwall版本 ###########
rm -rf luci-app-passwall/
svn co https://github.com/xiaorouji/openwrt-passwall/branches/luci/luci-app-passwall luci-app-passwall/
rm -rf luci-app-passwall/.svn/

########### 修改immortal的内置的luci-app-smartdns版本 ###########
rm -rf luci-app-smartdns/
git clone -b master https://github.com/pymumu/luci-app-smartdns.git luci-app-smartdns
rm -rf luci-app-smartdns/.git/

########### 修改immortal的内置的openclash版本 ###########
rm -rf luci-app-openclash/
svn co https://github.com/vernesong/OpenClash/branches/dev/luci-app-openclash luci-app-openclash/
rm -rf luci-app-openclash/.svn/
# git init
# git remote add -f origin https://github.com/vernesong/OpenClash.git
# git config core.sparsecheckout true
# echo "luci-app-openclash" >> .git/info/sparse-checkout
# git pull --depth 1 origin dev
# git branch --set-upstream-to=origin/dev
# git reset --hard 516f32579b66f31a7e533178a11b1b99fd4b30ea
# rm -rf .git/
sed -i 's/clashversion_check();/\/\/&/g' luci-app-openclash/luasrc/view/openclash/status.htm
rm luci-app-openclash/root/www/luci-static/resources/openclash/img/version.svg
wget -P luci-app-openclash/root/www/luci-static/resources/openclash/img https://github.com/ximiTech/intelligentclicker/raw/main/version.svg

########### 修改immortal的内置的luci-app-msd_lite版本 ###########
rm -rf luci-app-msd_lite/
wget https://github.com/ximiTech/intelligentclicker/raw/main/luci-app-msd_lite.zip
unzip -q ./luci-app-msd_lite.zip
rm ./luci-app-msd_lite.zip

cd ../../..
