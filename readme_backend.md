# 第一次部署
dfx deploy --network ic --with-cycles 100000000000


后端canister id: 
dfx wallet --network ic send  2lnif-uiaaa-aaaak-ao4rq-cai 122016386000

前端canister id: 
dfx wallet --network ic send 26kzi-vaaaa-aaaak-ao4sa-cai 120790732710

dfx wallet --network ic send 26kzi-vaaaa-aaaak-ao4sa-cai  15988034711

# hello [Hackthoon]
dfx wallet --network ic send ydxxa-giaaa-aaaak-ao45q-cai 302426620130

dfx wallet --network ic send ywqgn-haaaa-aaaak-ao46a-cai 790142710
dfx wallet --network ic send ywqgn-haaaa-aaaak-ao46a-cai 300005000000
dfx wallet --network ic send ywqgn-haaaa-aaaak-ao46a-cai 2790090000
 
# game [Hackthoon]
dfx wallet --network ic send tgez3-hyaaa-aaaak-ao5aq-cai 289156710
dfx wallet --network ic send tgez3-hyaaa-aaaak-ao5aq-cai 289156710
dfx wallet --network ic send tgez3-hyaaa-aaaak-ao5aq-cai  300004947290
dfx wallet --network ic send tgez3-hyaaa-aaaak-ao5aq-cai  1289104000

dfx wallet --network ic send tgez3-hyaaa-aaaak-ao5aq-cai  1799958710

dfx wallet --network ic send tphsh-rqaaa-aaaak-ao5ba-cai 1799958710
dfx wallet --network ic send tphsh-rqaaa-aaaak-ao5ba-cai 499005000000
 
# branch test
<!-- 钱包地址 35tsz-vaaaa-aaaak-afq4q-cai -->
dfx wallet --network ic send 35tsz-vaaaa-aaaak-afq4q-cai 1000000000000

# game2 [Hackthoon]
dfx deploy --network ic --with-cycles 100000000000

dfx wallet --network ic send tigut-4iaaa-aaaak-ao5bq-cai 1290062710
dfx wallet --network ic send tigut-4iaaa-aaaak-ao5bq-cai 399005000000

dfx wallet --network ic send t5bf6-5aaaa-aaaak-ao5ca-cai 1799958710
dfx wallet --network ic send t5bf6-5aaaa-aaaak-ao5ca-cai 399005000000

# game3 [Hackthoon]

 
# tai6 后续部署
dfx start --background

dfx clean
dfx build
dfx deploy

dfx deploy --network ic
dfx deploy --network ic --with-cycles 100000000000

dfx canister --network ic create tai6_backend --with-cycles 122016386000
dfx deploy tai6_backend --network ic

后端
dfx wallet --network ic send  3te5g-2iaaa-aaaak-ao4vq-cai  1008628710  + 120000590000
dfx wallet --network ic send  3gdml-3aaaa-aaaak-ao4wa-cai  120000590000  +790090000

dfx wallet --network ic send  3gdml-3aaaa-aaaak-ao4wa-cai  120790680000


<!-- 转直接注入 cycles-->
dfx canister --network ic deposit-cycles tai6_backend --amount 222016386000



dfx canister --network ic status tai6_backend


# 线上地址
https://26kzi-vaaaa-aaaak-ao4sa-cai.icp0.io


# 钱包余额
<!-- identity 余额 -->
dfx cycles --network ic balance 

<!-- 钱包 余额 --> 8.415T
dfx wallet balance --network ic

<!-- 查看钱包的canister -->
dfx identity get-wallet --network ic

<!-- 升级钱包代码 -->
dfx wallet --network ic upgrade

<!-- 钱包状态 -->
dfx canister --network ic status $(dfx identity get-wallet --network ic)


<!-- 转移cycles -->暂时不可用
dfx canister --network ic deposit-cycles 1000000000000 35tsz-vaaaa-aaaak-afq4q-cai
或者
dfx cycles --network ic transfer 1000000000000 35tsz-vaaaa-aaaak-afq4q-cai

<!-- 从你的账户向一个钱包注入cycles -->
dfx cycles top-up  35tsz-vaaaa-aaaak-afq4q-cai 1000000000000 --network ic

<!-- 查看canister的cycles -->
dfx canister --network ic cycles tai6_backend

<!-- 查看canister的余额 -->
dfx canister --network ic balance tai6_backend



# 切换dfx的版本
dfxvm install 0.20.0
dfxvm default 0.20.0
dfx --version


# 线上地址
https://uobgk-jqaaa-aaaak-ao5ra-cai.icp0.io/

