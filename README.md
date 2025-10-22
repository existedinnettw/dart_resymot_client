# dart_resymot_client

dart resymot async client library.

Firstly, `cd` to the project floder.

Use resymot rpc server's url as RESYMOT_SERVER environment vairable:

````bash
RESYMOT_SERVER="http://127.0.0.1:8383"

````

Then add FEED_RATE environment vairable to control robot speed:

````bash
FEED_RATE="0.3"
````

To run tests(ex. run case "testJog"):

````bash
dart test "./test/client_xyz_test.dart" -t "xyz" -x "dual || home"
````
