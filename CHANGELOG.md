# Changelog

## [0.4.0](https://github.com/rancher/terraform-aws-server/compare/v0.3.1...v0.4.0) (2024-03-13)


### Features

* added more official cloud init support, added cloud init debugging logs, added a default private ip selection, updated dev functions ([#54](https://github.com/rancher/terraform-aws-server/issues/54)) ([29b186c](https://github.com/rancher/terraform-aws-server/commit/29b186cc4754b6c72cdb727c6a361102d797c72a))


### Bug Fixes

* eip needs to be created to pass it ([#56](https://github.com/rancher/terraform-aws-server/issues/56)) ([5e9fc78](https://github.com/rancher/terraform-aws-server/commit/5e9fc78a690fbee077ef3c7e330d4c7404349e3c))
* full output was a debug, remove ([#58](https://github.com/rancher/terraform-aws-server/issues/58)) ([4ed2622](https://github.com/rancher/terraform-aws-server/commit/4ed262244fa472b8f345d3f4889d541c8b4e9a17))
* make sure default ip is always available, send owners from aws to image outputs, validate image names ([#57](https://github.com/rancher/terraform-aws-server/issues/57)) ([6d2cac7](https://github.com/rancher/terraform-aws-server/commit/6d2cac777b33a9277d4fb8c55d02852cce9fcc02))

## [0.3.1](https://github.com/rancher/terraform-aws-server/compare/v0.3.0...v0.3.1) (2024-03-08)


### Bug Fixes

* remove unnecessary variables in tests ([#53](https://github.com/rancher/terraform-aws-server/issues/53)) ([082e6d0](https://github.com/rancher/terraform-aws-server/commit/082e6d0733664ac82d01167a9e94b0ebe7929881))
* select zone for region tests and remove key and key_name when not necessary ([#52](https://github.com/rancher/terraform-aws-server/issues/52)) ([db4e01a](https://github.com/rancher/terraform-aws-server/commit/db4e01a3f2a534cc753be7ef426ea3cc94baf59e))
* update all tests to stop using the default vpc and subnet ([#50](https://github.com/rancher/terraform-aws-server/issues/50)) ([7bcdeeb](https://github.com/rancher/terraform-aws-server/commit/7bcdeebe8ba7ac14ca3e05a9e3d20a6ad3044cbc))

## [0.3.0](https://github.com/rancher/terraform-aws-server/compare/v0.2.1...v0.3.0) (2024-02-12)


### Features

* add eip and handle cloud-init scripts better ([#48](https://github.com/rancher/terraform-aws-server/issues/48)) ([3ca9ba0](https://github.com/rancher/terraform-aws-server/commit/3ca9ba05d1c130be745b65a315817dafc9b03815))

## [0.2.1](https://github.com/rancher/terraform-aws-server/compare/v0.2.0...v0.2.1) (2024-02-09)


### Bug Fixes

* update access mod in examples ([#47](https://github.com/rancher/terraform-aws-server/issues/47)) ([0d7dbaa](https://github.com/rancher/terraform-aws-server/commit/0d7dbaab1f89022eee276f844fddbde010e3d112))
* update image search for rhel and explain why ([#44](https://github.com/rancher/terraform-aws-server/issues/44)) ([90fb039](https://github.com/rancher/terraform-aws-server/commit/90fb0395d001fe851268e0f73496845f12b6d81f))
* update required version of tf to the latest open source version ([#46](https://github.com/rancher/terraform-aws-server/issues/46)) ([1e7e0d4](https://github.com/rancher/terraform-aws-server/commit/1e7e0d4715f94a1092463885f06cc29f3aee1db6))

## [0.2.0](https://github.com/rancher/terraform-aws-server/compare/v0.1.3...v0.2.0) (2024-02-07)


### Features

* add ability to disable ssh and specify private ip ([#41](https://github.com/rancher/terraform-aws-server/issues/41)) ([16b806e](https://github.com/rancher/terraform-aws-server/commit/16b806ee6cd1f4afabd9b2b6e63392b2041b62d6))


### Bug Fixes

* remove unneccesary nix cache ([#43](https://github.com/rancher/terraform-aws-server/issues/43)) ([512e893](https://github.com/rancher/terraform-aws-server/commit/512e8931199a684ce9b1ac88fbac430e13948e1f))

## [0.1.3](https://github.com/rancher/terraform-aws-server/compare/v0.1.2...v0.1.3) (2024-01-31)


### Bug Fixes

* bump actions/cache from 3 to 4 ([#36](https://github.com/rancher/terraform-aws-server/issues/36)) ([56f5fb3](https://github.com/rancher/terraform-aws-server/commit/56f5fb3b5d41aa3efc1fc349efc385b0e011423c))
* bump peter-evans/create-or-update-comment from 3 to 4 ([#38](https://github.com/rancher/terraform-aws-server/issues/38)) ([dc03929](https://github.com/rancher/terraform-aws-server/commit/dc03929f9feb48ba0a4c79521e63d1563be171cd))

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
