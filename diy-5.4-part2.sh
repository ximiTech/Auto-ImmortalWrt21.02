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

########### 维持xray-core的版本 ###########
# sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.7.2/g' feeds/passwall_packages/xray-core/Makefile
# sed -i 's/PKG_RELEASE:=.*/PKG_RELEASE:=1/g' feeds/passwall_packages/xray-core/Makefile
# sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' feeds/passwall_packages/xray-core/Makefile

########### 维持xray-plugin的版本 ###########
# sed -i 's/PKG_VERSION:=.*/PKG_VERSION:=1.7.2/g' feeds/passwall_packages/xray-plugin/Makefile
# sed -i 's/PKG_RELEASE:=.*/PKG_RELEASE:=1/g' feeds/passwall_packages/xray-plugin/Makefile
# sed -i 's/PKG_HASH:=.*/PKG_HASH:=skip/g' feeds/passwall_packages/xray-plugin/Makefile

########### 替换immortal的内置的smartdns版本 ###########
cd feeds/packages/net
rm -rf smartdns/
svn co https://github.com/coolsnowwolf/packages/trunk/net/smartdns smartdns/
rm -rf smartdns/.svn/
# sed -i 's/1.2022.38/1.2023.41/g' smartdns/Makefile
sed -i 's/PKG_SOURCE_VERSION:=.*/PKG_SOURCE_VERSION:=e38d5eaecca631ebc9b66e2c37e1986f2d58c27b/g' smartdns/Makefile
sed -i 's/PKG_MIRROR_HASH:=.*/PKG_MIRROR_HASH:=skip/g' smartdns/Makefile
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

########### 修改immortal的内置的openclash版本 ###########
rm -rf luci-app-openclash/
svn co https://github.com/vernesong/OpenClash/branches/dev/luci-app-openclash luci-app-openclash/
rm -rf luci-app-openclash/.svn/
sed -i 's/clashversion_check();/\/\/&/g' luci-app-openclash/luasrc/view/openclash/status.htm
rm luci-app-openclash/root/www/luci-static/resources/openclash/img/version.svg
wget -P luci-app-openclash/root/www/luci-static/resources/openclash/img https://github.com/ximiTech/intelligentclicker/raw/main/version.svg

########### 修改immortal的内置的luci-app-msd_lite版本 ###########
rm -rf luci-app-msd_lite/
wget https://github.com/ximiTech/intelligentclicker/raw/main/luci-app-msd_lite.zip
unzip -q ./luci-app-msd_lite.zip
rm ./luci-app-msd_lite.zip

cd ../../..