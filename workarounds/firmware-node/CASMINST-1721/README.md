# CASMINST-1721 WAR - Download POR firmware for HPE NCNs
The LiveCD does not contain the required firmware versions for HPE NCNs as specified in the 252-FIRMWARE-NODE procedure.
The following WAR will describe the process to download the required HPE Firmware from the public HPE support site.

## Overview
| Vendor | Model                 | Version                            |
| ------ | --------------------- | -----------------------------------|
| HPE    | iLO5                  | 2.33 [Download Link][1]            |
| HPE    | A41 DL325 Gen10 BIOS  | 11/13/2020 2.44 [Download Link][2] |
| HPE    | A42 DL385 Gen10+ BIOS | 10/30/2020 1.38 [Download Link][3] |
| HPE    | A43 DL325 Gen10+ BIOS | 10/30/2020 1.38 [Download Link][4] |

[1]: https://support.hpe.com/hpsc/swd/public/detail?swItemId=MTX_11b0bf7deb9d4b5aa46ee921ef
[2]: https://support.hpe.com/hpsc/swd/public/detail?swItemId=MTX_66638ca480054764a2dc4803f1
[3]: https://support.hpe.com/hpsc/swd/public/detail?swItemId=MTX_c530466269d14674bdca97394e
[4]: https://support.hpe.com/hpsc/swd/public/detail?swItemId=MTX_5ed1b5a914b844caab3780d293

## Procedure
1. Download Firmware from HPE Public support site. In a web browser download the the required firmware files from the HPE
    Public support site. Click the `Download` button for the each of the following files.
    > When downloading files from HPE public support pages, you may see a `Support validation required` popup. If you do 
    > click `Sign in now` to sign in using your HPE Passport. If you do not have a account, please create one.

    1. iLO5 firmware [download link](https://support.hpe.com/hpsc/swd/public/detail?swItemId=MTX_11b0bf7deb9d4b5aa46ee921ef) for `ilo5_233.fwpkg`
    2. HPE A41 DL325 Gen10 BIOS [download link](https://support.hpe.com/hpsc/swd/public/detail?swItemId=MTX_66638ca480054764a2dc4803f1) for `A41_2.44_11_13_2020.signed.flash`
    3. HPE A42 DL385 Gen10+ BIOS [download link](https://support.hpe.com/hpsc/swd/public/detail?swItemId=MTX_c530466269d14674bdca97394e) for `A42_1.38_10_30_2020.signed.flash`
    4. HPE A43 DL325 Gen10+ BIOS [download link](https://support.hpe.com/hpsc/swd/public/detail?swItemId=MTX_5ed1b5a914b844caab3780d293) for `A43_1.38_10_30_2020.signed.flash`

2. Copy the firmware over to the PIT Node. In the directory were the firmware files were downloaded.
    > Replace `eniac-ncn-m001` with a hostname/IP for the PIT
    ```bash
    linux# scp ilo5_233.fwpkg root@eniac-ncn-m001:/var/www/fw/river/hpe
    linux# scp A41_2.44_11_13_2020.signed.flash root@eniac-ncn-m001:/var/www/fw/river/hpe
    linux# scp A42_1.38_10_30_2020.signed.flash root@eniac-ncn-m001:/var/www/fw/river/hpe
    linux# scp A43_1.38_10_30_2020.signed.flash root@eniac-ncn-m001:/var/www/fw/river/hpe
    ```

    After copying the firmware of the PIT the `/var/www/fw/river/hpe` directory should look similar to the following
    ```bash
    pit# ls -1 /var/www/fw/river/hpe
    A41_2.42_07_17_2020.signed.flash
    A41_2.44_11_13_2020.signed.flash
    A42_1.30_07_18_2020.signed.flash
    A42_1.38_10_30_2020.signed.flash
    A43_1.30_07_18_2020.signed.flash
    A43_1.38_10_30_2020.signed.flash
    ilo5_230.bin
    ilo5_233.fwpkg
    ```

3. Now return the the 252-FIRMWARE-NODE procedure, the required HPE firmware files should now be present on the PIT node. 
