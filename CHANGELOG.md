# Changelog

## [1.1.2](https://github.com/rancher/terraform-aws-server/compare/v1.1.1...v1.1.2) (2024-07-09)


### Bug Fixes

* add address family and respond appropriately ([#87](https://github.com/rancher/terraform-aws-server/issues/87)) ([3c4f97a](https://github.com/rancher/terraform-aws-server/commit/3c4f97af0d0d4e9fe423b54326847db3ab991088))

## [1.1.1](https://github.com/rancher/terraform-aws-server/compare/v1.1.0...v1.1.1) (2024-07-04)


### Bug Fixes

* do not force address select ([#85](https://github.com/rancher/terraform-aws-server/issues/85)) ([ff29bdc](https://github.com/rancher/terraform-aws-server/commit/ff29bdce6b8828f6344a1981fd3a479126147008))

## [1.1.0](https://github.com/rancher/terraform-aws-server/compare/v1.0.4...v1.1.0) (2024-07-01)


### Features

* upgrade to new access module ([#83](https://github.com/rancher/terraform-aws-server/issues/83)) ([dd15b26](https://github.com/rancher/terraform-aws-server/commit/dd15b26b700729ec3629b82095bd22f0655ad84e))

## [1.0.4](https://github.com/rancher/terraform-aws-server/compare/v1.0.3...v1.0.4) (2024-06-05)


### Bug Fixes

* resolve failing user setup ([#81](https://github.com/rancher/terraform-aws-server/issues/81)) ([f4d2167](https://github.com/rancher/terraform-aws-server/commit/f4d21679e64b954044f26461d800a98b3d0be7e1))

## [1.0.3](https://github.com/rancher/terraform-aws-server/compare/v1.0.2...v1.0.3) (2024-05-29)


### Bug Fixes

* consolidate image tests ([#77](https://github.com/rancher/terraform-aws-server/issues/77)) ([a5f63e3](https://github.com/rancher/terraform-aws-server/commit/a5f63e3803030734cbfea96a4abd049d50cf0953))
* new selection process ([#74](https://github.com/rancher/terraform-aws-server/issues/74)) ([32d7021](https://github.com/rancher/terraform-aws-server/commit/32d7021d10e0ecd690022bedae8547bd1349b039))
* remove unnecessary tests ([#80](https://github.com/rancher/terraform-aws-server/issues/80)) ([f0f8e5f](https://github.com/rancher/terraform-aws-server/commit/f0f8e5ffc36c96a8894c1af5f2dbfa878521f33f))
* update docs with new change ([#79](https://github.com/rancher/terraform-aws-server/issues/79)) ([37c9345](https://github.com/rancher/terraform-aws-server/commit/37c9345061d4ca76e608f5fa36f0f938ba9de05e))
* update image names ([#76](https://github.com/rancher/terraform-aws-server/issues/76)) ([6625eea](https://github.com/rancher/terraform-aws-server/commit/6625eeadbd8758b3b7b05ffd96313b9f773b6c58))
* update tests ([#78](https://github.com/rancher/terraform-aws-server/issues/78)) ([8e63087](https://github.com/rancher/terraform-aws-server/commit/8e6308779ad7f5955f37c1aed0396e197edc0e5d))

## [1.0.2](https://github.com/rancher/terraform-aws-server/compare/v1.0.1...v1.0.2) (2024-05-24)


### Bug Fixes

* more images found, add product codes ([#72](https://github.com/rancher/terraform-aws-server/issues/72)) ([1454a64](https://github.com/rancher/terraform-aws-server/commit/1454a64e6ddd4b801417348957ff2fe97a3694f3))

## [1.0.1](https://github.com/rancher/terraform-aws-server/compare/v1.0.0...v1.0.1) (2024-05-21)


### Bug Fixes

* collision domains ([#71](https://github.com/rancher/terraform-aws-server/issues/71)) ([dbc3c4d](https://github.com/rancher/terraform-aws-server/commit/dbc3c4ded880f65f0872f60f6a748144f71254ca))
* normalize and validate out put ([#69](https://github.com/rancher/terraform-aws-server/issues/69)) ([3b5ae2b](https://github.com/rancher/terraform-aws-server/commit/3b5ae2be5a87e80d7292e39662ca03792a674399))

## [1.0.0](https://github.com/rancher/terraform-aws-server/compare/v0.4.1...v1.0.0) (2024-05-04)


### ⚠ BREAKING CHANGES

* adjust for new abilities ([#62](https://github.com/rancher/terraform-aws-server/issues/62))

### Bug Fixes

* add random name to project ([#65](https://github.com/rancher/terraform-aws-server/issues/65)) ([08163c2](https://github.com/rancher/terraform-aws-server/commit/08163c2fc4ad76b5bce0971c55e64af8a1fd32c0))
* example versions ([#64](https://github.com/rancher/terraform-aws-server/issues/64)) ([560f073](https://github.com/rancher/terraform-aws-server/commit/560f073362ddd3bdaf2483fd1e560e9980ca6771))
* Fix release ([#66](https://github.com/rancher/terraform-aws-server/issues/66)) ([262ff39](https://github.com/rancher/terraform-aws-server/commit/262ff3914dff52d1815a7c96de8d9af4a8cfb058))
* make example network names static ([#67](https://github.com/rancher/terraform-aws-server/issues/67)) ([ee779ba](https://github.com/rancher/terraform-aws-server/commit/ee779ba41c85137af8178983a59f219d73c8b475))
* make the tests a bit more random ([#68](https://github.com/rancher/terraform-aws-server/issues/68)) ([5561bb0](https://github.com/rancher/terraform-aws-server/commit/5561bb02b887f549242670b88090847d4310ea35))


### Code Refactoring

* adjust for new abilities ([#62](https://github.com/rancher/terraform-aws-server/issues/62)) ([5b24ad5](https://github.com/rancher/terraform-aws-server/commit/5b24ad5038f9c10a98a904cda53025f0446896d3))

## [0.4.1](https://github.com/rancher/terraform-aws-server/compare/v0.4.0...v0.4.1) (2024-03-14)


### Bug Fixes

* ignore subnet id changes and specify when server gets recreated ([#59](https://github.com/rancher/terraform-aws-server/issues/59)) ([759efac](https://github.com/rancher/terraform-aws-server/commit/759efac5def838e87ce926c2a63e3bc7887df47f))
* this trigger is undertermined at plan time ([#61](https://github.com/rancher/terraform-aws-server/issues/61)) ([fd6ed07](https://github.com/rancher/terraform-aws-server/commit/fd6ed078e1f171080d84c00ebf66a3b064e02c0c))

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
