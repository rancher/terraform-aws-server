# Changelog

## [0.1.2](https://github.com/rancher/terraform-aws-server/compare/v0.1.1...v0.1.2) (2024-01-29)


### Bug Fixes

* attach security group as a separate resource than the server ([#37](https://github.com/rancher/terraform-aws-server/issues/37)) ([6e8ad95](https://github.com/rancher/terraform-aws-server/commit/6e8ad9540a40661def83d707bb910dbc4a41f8bf))

## [0.1.1](https://github.com/rancher/terraform-aws-server/compare/v0.1.0...v0.1.1) (2023-12-05)


### Bug Fixes

* actually remove test ([#35](https://github.com/rancher/terraform-aws-server/issues/35)) ([173085b](https://github.com/rancher/terraform-aws-server/commit/173085b3ee4c8232f548f1bd78bd130ac1b48a65))
* add cloud-init timeout, update dev env, update workflows ([#28](https://github.com/rancher/terraform-aws-server/issues/28)) ([89f0ff0](https://github.com/rancher/terraform-aws-server/commit/89f0ff09d9d1e0d515cfdd627e68b4e46151829b))
* add skip ci to release pr ([#26](https://github.com/rancher/terraform-aws-server/issues/26)) ([ed1f940](https://github.com/rancher/terraform-aws-server/commit/ed1f94028cdf7aae199eca275d24f271ab6456fa))
* deploy a basic server to test selecting ([#32](https://github.com/rancher/terraform-aws-server/issues/32)) ([855aa88](https://github.com/rancher/terraform-aws-server/commit/855aa888f2703b01a199c5ca794c2fd3b9d91e79))
* don't specify release title ([#29](https://github.com/rancher/terraform-aws-server/issues/29)) ([318684a](https://github.com/rancher/terraform-aws-server/commit/318684aa7558c09a27553ba0b4e88239885b1e66))
* show cloudinit timeout ([#30](https://github.com/rancher/terraform-aws-server/issues/30)) ([e90f8c7](https://github.com/rancher/terraform-aws-server/commit/e90f8c711837397937eeca55313c59d325328691))
* temporarily remove the select_server test ([#34](https://github.com/rancher/terraform-aws-server/issues/34)) ([b69a50c](https://github.com/rancher/terraform-aws-server/commit/b69a50c723b76e67d208b051c1a6e542bf0ce37c))
* use the preset ami ([#33](https://github.com/rancher/terraform-aws-server/issues/33)) ([a99a71e](https://github.com/rancher/terraform-aws-server/commit/a99a71eebc204c403395e444911375ab3efaee2f))

## [0.1.1](https://github.com/rancher/terraform-aws-server/compare/v0.1.0...v0.1.1) (2023-10-27)


### Bug Fixes

* add skip ci to release pr ([#26](https://github.com/rancher/terraform-aws-server/issues/26)) ([ed1f940](https://github.com/rancher/terraform-aws-server/commit/ed1f94028cdf7aae199eca275d24f271ab6456fa))

## [0.1.0](https://github.com/rancher/terraform-aws-server/compare/v0.0.16...v0.1.0) (2023-10-27)


### Features

* add ability to inject script into cloud-init ([f97eee5](https://github.com/rancher/terraform-aws-server/commit/f97eee5bc13b83fef1dbb6275b6ca9b0620714d3))
* use ~ for workfolder rather than hard coding home ([4a08656](https://github.com/rancher/terraform-aws-server/commit/4a08656ad59b3d62fd54f2b46c0f385438756f8a))


### Bug Fixes

* make sure the default value is home, replace ~ with home ([8060229](https://github.com/rancher/terraform-aws-server/commit/80602294eca0bfa541e6f8de67ad41eb189137c5))
* update tf directory ([4907a74](https://github.com/rancher/terraform-aws-server/commit/4907a74923f19a9ac3b26815f243239d72430353))
* update workflow job versions and fix tf setup variable ([dd3d294](https://github.com/rancher/terraform-aws-server/commit/dd3d2945aff0286e5a031de3621984cb884203af))
