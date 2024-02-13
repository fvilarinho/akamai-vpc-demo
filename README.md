## Akamai VPC Demo

## 1. Introduction

VPC or Virtual Private Cloud is a concept where it is possible to set up private networks in a Cloud infrastructure.

It is a good practice to use VPCs to protect your applications from the outside world (Internet) and consequently 
set up an environment with controlled and managed access.

We'll show you how easy and fast it is to set up your VPC using Akamai Connected Cloud resources on a global scale.

All this in an automated way with Terraform recipes.

## 2. Maintainers

- [Felipe Vilarinho](https://www.linkedin.com/in/fvilarinho)

If you want to collaborate in this project, reach out us by e-Mail.

You can also fork and customize this project by yourself once it's opensource. 
Follow the requirements below to set up your environment.

## 3. Requirements

- [`Terraform 1.4.x`](https://www.terraform.io)

Just execute the shell script `deploy.sh` to start the provisioning and execute the shell script `undeploy.sh` for
de-provisioning.

The infrastructure provisioning state will be stored in an object storage. By default, we are using the Akamai Connected
Cloud object storage. So, before start the deployment, you need to create your bucket and credentials. To do that, 
follow the these [instructions](https://www.linode.com/docs/products/storage/object-storage/get-started/).

Environments variables needed:
- `CREDENTIALS`: Contains all credentials (in key/value format) needed for the provisioning. Please check the template
  in `iac/credentials.template`.

## 4. Architecture

Follow this [diagram](https://viewer.diagrams.net/?tags=%7B%7D&highlight=FFFFFF&layers=1&nav=1&title=VPC#R7RxXd6rM9tfkMVl04VEQFOygWF6%2BhTDCCAICUvz1d7CkKMkxN%2FEcT3FFA3sKM7vP3jM8kMI6b0ZG6HQDC3gPBGblD2TjgSAIkiHRvxJSHCA4hREHiB1B6wh7AWhwB45A7AjdQgvEbyomQeAlMHwLNAPfB2byBmZEUZC9rbYMvLdPDQ0bXAA00%2FAuoRNoJc4RijPcS0ELQNs5PpolaoeChWG6dhRs%2FePzHghS2n8OxWvj1NdxorFjWEH2CkSKD6QQBUFyuFrnAvBK5J7QdmgnvVP6PO4I%2BMlVDXaZ5rhAbJOYHoTWDKPk3uOxl9TwtuA0jf1gk%2BKEoP0UQdkJ%2FkDymQMToIWGWZZmiCcQzEnW3rE4TqLAfUYkmiNvGbHz3Lq8GRhJAiIfQVj0IBZBL2dyGhaIEpC%2FAh1n1gTBGiRRgaocSx9x%2BtDkxIa1I9azVzQl6GMl5xU9aepY0zgykv3c%2BQsy0cURn9W4DTN%2BLO%2BURcNe07QyJ1NxtX0kmB8jt2SgEoXLwE%2B0I7iCsu%2Fh41ksjMWpR%2BxDPJHYGzSRxCWaqBPqXmOJvBmWvpsDl9DzhMALon1bcrkEjGk%2Bc%2BarEqvGLTCskv0%2BJuePmfKIXfpK5BLcrZBLViCX8ZISHaHhv8Eys9mWmmjPiY%2FxXk3XUQWcCvM9jk7l6Mo%2B%2Ft93tDgBZL8Ua5CgRk0jAZlRYqIcPoHpgx761UCEcHdqh0oW530h2GFcJ%2FB3MoJh1YxKRlhQDI1RN2GEk5l8K3U18om%2B5AyygjNup5uwC%2BQCC9nF420QJU5gB77hiS9Q%2FgX9pdi81OkEQXhE%2BgokSXE08sY2Cd6SBOQwmZbN0fwPd7NjZ%2BV1I399Uxxv4sSIknpp6MtxhcA%2FwSRYTvnQwLfOaiDIq%2FJLq4QoHBWvhlLezk6jLG9eBrO%2FO43mkywSB9vIBB9UPPIBmo8NPurwKMgljT5kuAh4RgLTt77Nt3MPfWOdfT%2BiirMVfkSVDsfJW4nqFV7Eb4ts9u6wTZD3oxjxHyjGS6X2sRr8buVFXqm8mLtSXqeF53UChd3C47Qjw4KICK%2FKgLGwWPqWwka9lTUCu5Q1rkLU6Js5%2Fp%2Fy%2FP8cOjBndKhYgv1cOhAVdDjz7XtBGaOp9Nz%2FAoqdWalnSfplFKta1v0FdCCxe1Nh1F9KCOLedFjViuSfDntNsnPz%2F6uVGFElO2ck07aLQ0AJv4puCBXJW%2BIYHrTLSLMJyuAUApQIg6bh1Y8Fa2hZBxcexHB3jKKWRAoD6Cf7OdP8A90o%2B0Je%2ByEu9irSfaKhH%2FjgjBmOoJtR9HylWhFtrIzk3oygV8jgM0GJfwS9FNHz1fCvpuj7EloGiR%2B%2BEj3WB2hImIY060G6sUf07YEM%2FSogikHxij8OD%2FudWOQH2Zxv4pfHs5RXReyE%2FakKgP2xN3TKd10i5cN81mfQUjtTjJU5Lq4iE3i7HBfBfcZP%2FHwMz6IBa1FVTgdLLEiG%2BYTWYq9G9%2F0kuaoCCd%2Bkp67Kcn2Y0PpQe32F6AsMkICpIjoGWIytTqx%2FlejvJLSoSx74qeks8lKe%2FqWzHr4vnXVkkB9HhK8NCZ9k9k5iwuSnIiq%2FtazeQY6F%2FFTY5DfD9v2ltEj6fpTjr0ppXa3ATlsQf6jAqPtSYJ%2FKEn8%2BrHWFh1kR1uJqFlar3VLc7i2pRdb%2BTjrcW1KLrFqL%2FpKA8L1S7N6SWuSn1sh%2FDh3uLql1YoS%2FjhD3ltSi3o9r%2FNNhB5LdW1KLIi5I9pzyuNxY9ufErr%2B8KP3lqY7LAMAz4ah%2FhHu44yTVz8pSlQ8ps1QTI3agbyeB%2F%2FflqD4v59wZu1REQ6o09M3Yhb7U0Bf0guv9mUHeiMPDicMlzEvLyYcggmgYJcUa6FkwjMHgBfQhgZ9P%2F5VEfD4Ttw96ICuM%2BGm0j6uQCHB8fAOubTRFDyKbLhlmGUP4z4IRGlFQ4kGCx0zEf6YXbK2nOLUrTe2nj9LRBPFUe0O0xwpPCK9RT8wl3XD8ZoR7%2FyzTl%2BW8hcb4cDqsJARRGETGXuZ7IMmCyD1KPq%2F%2ByRL%2FaUYhaeyMTbhLPiGq8kC3Oytxeazp64HMU27l%2BWaf5XlJtLyTW7km0%2FMdAc9rI5Ynzfd9Ectj00HJoK8DC2f5d%2FptD4cY7LHRC70v%2Bqlh3BPH0QRLYCxHcKfhn3rlnlAVFsNrNI4RFIsxb59yQMfFU%2FZc9TzXL2ijK%2BKtSOWHBz1%2BMCcnie8YC%2BANkAQnMCglfxEkSbBGFbyygH8%2BVn4SXwssje1e7ZzrjKRk4UsztX9g%2FQTFXpkUy0gMpAsPt4QU%2BsjCCFDn%2B2qGtZt2UEefnjZ2xLGNrrrlT0MW6l30XzAcj4nLCkuP7%2BridK8tyz8WwfjFBE92Jtlt8dmylbPmrrsbICtSasp0hHFdRRi6g0aGblfIYeMH%2Bx9H0cZ%2ByIB1GjFcaEzWMNi0uXSBjSV%2BWHbDDhoFkUSLbW3LjFx6MCcsT0efGiAT1KECph6jwNkaXQqmrxQNm%2Bpu2jBYNPOY7O2s%2BlDkZU1c6bile%2FOJTlj%2BbJfLQhMNuSmLnjjUVcrvExYxa8Muz0u5jrS8yXNZbVI7zq7lMA254boSI4YD3wBzUVP8VNwETq8RinWVP3yHTt4DHGqwS7qR3kxkd5Dg3GrcTpVaK9nkowCVqR0qxLSZKkKfZ0KEAmsptiQ8paa9Vs7PeZGoL9lGDptFQ4E7XAWFLeg9ztWsaGbl0yk23NUM0rcHVlMR5BZcZkt5zZAdM0d9uYXcClh6UuTeoOloOUMUGFz3G%2FK2yzQZAqpFR3Jlu6tIsgBNpy7DyRDWM3dst5VCrENlLsgNQdXqgS8PBdmrrBsohpxGzW5oDrDdJplv11Odl%2BetzlDmas4sx7mx1tTSUEcSFnJTXG3RO9%2FOnBCQcCdDGs8G%2BUrPxmNd7ND40lzg7EbraJ1lV572hsP10l3CRqK0lskW1GjfUYSOP9j1dHbOeqRA7wKiv%2FSotaoHlu%2FMpuxssIoHfr89XyqryItFyAzUaTLiA1VK0toEOQ08clqlJvr2tvl6QgBzhGCF5fm7NO7JWl7MzHUbFW83tRHf3SJ9wM%2B0PvrlBmCbwnwdipOmFhjWwB0NNnHBhSQERr%2Bv13o5XXQ2daej%2B8hH47cLkck9kkndLdslDIJtN2UYFloxC%2BWtptFMOrbMYRPKMJ%2BrI04KOJ3EJqqIFJTUStM2Ly8jGQoe1rfUPG7OZOigkTV7a7pjp%2BGwwFvj9jBGDVYEu6Gm%2FUk%2FzuVcnOM1jMk72Q5Lu2pzEjU8kqjNcUh5VNAfrFS3EDu4m88gXSv6rVwuRoLPZDObq3Xo8ZIi5OFQdKSOHmv11IyluN2tD6GCRqZJKyU9CIE6VuvaOLKVySBJJotCq0PTnq3bNXtmYmKNhV1IQSuqu8yEtzy1XhdVb5NZjIjP4nCDcGPz5tAdR5PGQlvVETdp7E4RnQbvaxkvGp7bN%2BqWCurTuraMNhTusrO0m3XXTKKI8TIUe1vFVD1oLBw9detjcpKEumvOEnuUG6QwmKPrlCrApsEE0xx5OyNT3pRlqdDI5xlpaDlyfDKFikdOc9LhB%2BOBa4WxU6PUxg4rgDzO5mw8cERCDjB2Ms2gALVOySdDZaQatWY7wQPDgUAcTcoSjRp6RdbHlzHbrY%2FM5oqy26gXdWZ6jO2EaVd3WdnehvPOGG9SeiOXhs5EzSDbHPECZtc37nSs8UZLEOOJ0aOEZcOWhpsxYsZ5TLjtqDCCiY1knpgYBao7k9dBW2knmqrorj7bZPOuNFnUx9N0Io0h0hHFfIOvmWwjzo2YZ1bOaJEqG6fNK1licvW5JmttvSM5oehCGralbgxDMVTakjEvGV%2FvyEOo2qORvhXWCWmLoV%2BL6JzfqXQGF7xrg%2FmQZ31BzpSBF1gdtaHMgTh0XUpvOsI0aqyjcVaMhRE3G3mYPV1vcrxFT2Sr085gh3f9MZ8M%2FKaiCWYHzuwcXwydTdfNJsjOUF23MGe%2BrGTbVkkrISN0rU4qGWwJUoo1SZ0dKsOtpPGkMkRqEdsIJKVASm1rmmXWV100Ddw2BrCO93WPr2dwUARZK3LEZiG2iY6YqsuITHM5c5uMIyjbPtcQpzPFDXRZaRnlCwcG8Y7aqwehvtiIsi8u8tnEnLp6Ou6ryXYx4vt5oepKZ5fa24HGTHVOrEmdNZFo8zbNjckd31IAJs%2BdbFvbtVBPop%2B0Rq3aHEkO39b7kEHtWzmaRG0nS%2BuZHwaYGcREKrleZ4vqO5I4hNhUJxsrEFF9phH3YU%2FTRjVrjErtSWvR97vbrCd7bbXNMQuv6Gv4ClPhVGsa5hRr%2BSZGpIO%2BxSoey2UwKVa9KFmDlYuLU7lt9QfuZNnacJnNdUs9hZw3PnJYmFCF7JcD6I%2BImuBkJBhP4wlQnM2GLdjWRrVGa1R1OqIkpb5W8TxrtJbMnJZZB0QSxZndTu4UU2YqebkcARF2dkwvbgaEYC4tolM6Vqi5uekCb14aqKK%2FIgrAqIMYdtKEdZbrsN%2FKbE%2BJsTQmB6twoM4S3Fh1YFT4E7P0zJTmeLfJ21E3G3NRIINRy%2BnYlCY32WLse1Y6EUe01Gm50DXIbLMkiUSGRDIm5sg0dvGMpqPIi0aarkS7Ft8zlbG1k4RZShLieFbMJ2vRzcoZjl1dbWWIC3iN7uOCPlHbw1E0Guqz3FxKQsTiStgC%2FCTNRrWJQ2fAxa2FSXtbP9fsbiDmEylnPH%2Ba86FXLhelqW3lkLSapjFU6%2BLh2xBLa2Que7myGjcXg15Y%2BlV1pFj1vtqmhZksl47jtyziz53wirgL%2FTMD48wVG6zu0F92kqR8DVX9YAXR6g1195SiegDsiicTjQJBizgB5QVauO%2BXNjG6TpzteuEb0CtvMKz0JZl9gIHEy%2Bt4bZQ4kzwjRGN6hGbgP1po3W%2F7j8ADa1CGLbZwvwv6cRlEjxlYoOmDxzBC65lTTQQ3wvBxGQHwmO7DQk%2Br0D6Nnn%2F9eqpjBOBQEEQWeIunbwkGkGfBgIrAME1U8Bx%2BSpp8hek6u6InrR%2Bny86CnrZpfaw79DWvFrpcblct219FA96GE06bnE7bml5FBt7d5PSyV%2FOz8YTzWEHFvtFrIgXXnuv%2FYaDgSmXyxXgCjb0950DhxNP%2FG1I4yxdSp5O03x81qGTIG4Ywj0mKJHhOWPyLVL6w0Nn2JJK93LCOYzcKVFZywjckrdh3OOHlhMI%2FDnjFAWeHpS5fwFWVhvqOAwuV9OcuLdFP2JL7zimBF1vzKcvzxVMMV9mnSuTd%2FUuzqr2RCu%2Fj9jT%2FMMNwFLafTpdfdvjjo2FXb7OqUMTvnxL7su4WylQuqiDBCGT7JcI7OvxTG74%2Bf4IC7D8X%2BhqVkAzJkdb3rBmo813DFVsfySqzXLuVWr4iq%2FNLZPY79O3%2Fq%2F3fJfRrOf9IsG6dcGQw7umtdT8%2Fanrt%2BuCyp%2BfjOz9phXDNq31%2BWw58l5N%2BPoc8XmxUuZpH8PNdDzfjkMo3dhNfXjkQ760h666xNuBDuQVmfwgflKboaJL%2BrSVe3rtwvnm1YnsUiX%2FPaqIMKz6%2FIf7AQi%2Fv4SfF%2FwE%3D) to check out the architecture.

## 5. Settings

If you to customize by yourself, just edit the files located in the `iac` directory.

- `main.tf`: Defines the VPC provisioning providers and credentials.
- `variables.tf`: Defines the VPC provisioning variables.
- `vpc-credentials.tf`: Defines default credentials for connecting to the VPC.
- `vpc-stackscripts.yml`: Defines the VPC setup scripts.
- `vpc-gateways.yml`: Defines the VPC gateways provisioning recipe.
- `vpc-nodes.yml`: Defines the VPC nodes provisioning recipe.
- `vpc-site-to-site.tf`: Defines the VPC site-to-site recipe.
- `vpc-firewall.yml`: Defines firewall rules for connecting to the VPC.

Follow the documentation below as suggestion to setup the credentials and environment:

- [`How to create Linode credentials`](https://www.linode.com/docs/api)
- [`How to create the Linode object storage to store Terraform provisioning state`](https://www.linode.com/docs/guides/platform/object-storage)
- [`List of Linode regions`](https://www.linode.com/docs/api/regions/)
- [`List of Linode types`](https://www.linode.com/docs/api/linode-types/)
- [`List of Linode images`](https://www.linode.com/docs/api/images/)

## 6. Testing

After the VPC was created, you can connect into it using an OpenVPN client.

- [`TunnelBlick`](https://tunnelblick.net/downloads.html): For MacOS users.
- [`OpenVPN Client`](https://openvpn.net/client): For all operating systems.

Import the `.ovpn` file saved in this project directory, after the provisioning.

## 7. Other resources

- [`Terraform Linode Provider`](https://registry.terraform.io/providers/linode/linode/latest/docs)
- [`Linode documentation`](https://www.linode.com/docs/)
- [`OpenVPN Setup Script`](https://github.com/fvilarinho/openvpn-setup)

And that's it!!
