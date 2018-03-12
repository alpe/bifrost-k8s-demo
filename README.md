# Bifrost demo for minikube/ Google Kubernets Engine
Bifrost is an application to bridge Ehereum or Bitcoin blockchain to [Stellar  ](https://www.stellar.org/) to do an [initial coin offiering (ICO)](https://www.stellar.org/) or build an [anchor/exchange](https://www.stellar.org/developers/guides/anchor/) for these coins.

This project is a collection of kubernetes manifest files to setup a local or GKE kubernetes demo. Please note this is WIP and only for demo purpose. The docker artifacts for bifrost are custom branches, not officially supported and may be outdated already. Please see https://github.com/alpe/community-bifrost for the source code.

More about Bifrost can be found in the [package docs](https://github.com/stellar/go/tree/master/services/bifrost) or the [design document](https://docs.google.com/document/d/1lxn5YXuDWMpX2m9DvKNPHGgZHSG1mviPET_Dm55xRKI/edit#heading=h.ipw1sk4jppwc)

Remeber to use **Testnet** config only. This is not a valid, persistent nor secure prodction setup.

## Components
* [Ethereum-geth](https://github.com/ethereum/go-ethereum)
* [bitcoind](https://github.com/bitcoin/bitcoin)
* ~~[stellar-horizon](https://github.com/stellar/go/tree/master/services/horizon)~~
* ~~[stellar-core](https://github.com/stellar/stellar-core)~~

I use customized branches of:
* [bifrost](https://github.com/stellar/go/tree/master/services/bifrost)
* [bifrost-web](https://github.com/stellar/bifrost-js-sdk)


In this great article you can find everything to setup your token and accounts:
[Tokens on Stellar](https://www.stellar.org/blog/tokens-on-stellar/)

## Get started

1. Prepare accounts in Stellar testnet
You may find this Go code helpful for the setup operations: https://gist.github.com/alpe/bb604fb3d11261e3aea7924edfd004ba

2. Edit bifrost config for account/ token data
`manifests/bifrost-conf.yaml`
`manifests/bifrost-web-conf.yaml`

3. Deploy everything into your [minikube](https://github.com/kubernetes/minikube/)

4. Forward ports to access locally
```bash
 kubectl port-forward bifrost-xxxxxxxxx-yyyyy 8000:8000
 kubectl port-forward bifrost-web-xxxxxxxxx-yyyyy 8080:8080
```

5. Access 
Open `bifrost-web` in your browser: http://localhost:8080/

6. Send ETH to the account on the Ropsten testnet
* Use a wallet at https://www.myetherwallet.com/ and switch to Ropsten testnet.
* Receive some testnet `ETH`

```
curl -X POST  -H "Content-Type: application/json" -d '{"toWhom":"0x5CB26d92B3aDB284187F9CEe1b2A5F1F804A0719"}' https://ropsten.faucet.b9lab.com/tap
```

7. Send it to the address displayed on http://lcoalhost:8080

8. Transfer some test Ether via https://www.myetherwallet.com/#send-transaction

9. Watch transactions on the Stellar testnet: http://testnet.steexp.com

10. Access new account via https://stellarterm.com/#testnet

11. Check ETH has been received on your bip32 destination child account via https://www.myetherwallet.com/ 
 
## Resources
* [Bifrost](https://github.com/stellar/go/tree/master/services/bifrost)
* [Using Stellar for ICOs](https://www.stellar.org/blog/using-stellar-for-ico/)
* [Regulatory Strategy for Tokenization and ICOs](https://www.stellar.org/blog/regulatory-strategy-for-tokenization-and-ico/)


## Debugging

* Connect to bifrost database
```
# Connect to container
kubectl exec -it postgres-xxxxxxx-xxx /bin/sh
# Connect to DB
psql -U myuser -d myDB
```

## Ethereum Ropsten testnet
* Use a wallet at https://www.myetherwallet.com/ and switch to Ropsten testnet.
* Receive a testnet ETH
```
curl -X POST  -H "Content-Type: application/json" -d '{"toWhom":"0x5CB26d92B3aDB284187F9CEe1b2A5F1F804A0719"}' https://ropsten.faucet.b9lab.com/tap
```

## Troubleshooting

* Running into out of memory issues

Update resource limits in yaml file and apply again. See: http://kubernetes.io/docs/user-guide/compute-resources/


### Geth
* Geth is not syncing: `Please enable network time synchronisation in system settings.
Time in the container is not out ouf sync See https://github.com/kubernetes/minikube/issues/1378
Check current block is increasing:
```bash
kubectl port-forward ethereum-geth-xxxxxxxx-yyyyy 8545:8545
curl -X POST localhost:8545 -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}'
```
* Geth - `Ancestor below allowance`
See https://ethereum.stackexchange.com/questions/15403/synchronisation-failed-dropping-peer


### Postgresql DB
* Setup port forwarding
```bash
kubectl port-forward bifrost-demo-database  5433:5432
```
* Connect to port manually
```bash
telnet localhost 5433
```


### Push your own docker image to docker hub
See: https://docs.docker.com/docker-cloud/builds/push-images/

```bash
export DOCKER_ID_USER="username"
docker login
docker tag yourbifrost $DOCKER_ID_USER/yourbifrost
docker push $DOCKER_ID_USER/yourbifrost
```

## License
MIT License

Copyright (c) 2018 Alexander Peters

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
