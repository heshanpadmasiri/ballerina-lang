#!/bin/bash
cd /workspaces/ballerina-lang
bazel build //web-client:web-client
rm -f /workspaces/ballerina-lang/web-client-deploy/*.js
rm -f /workspaces/ballerina-lang/web-client-deploy/*.map
cp bazel-bin/web-client/*.js /workspaces/ballerina-lang/web-client-deploy/
cp bazel-bin/web-client/*.map /workspaces/ballerina-lang/web-client-deploy/
chmod +w /workspaces/ballerina-lang/web-client-deploy/web-client.js
echo "//# sourceMappingURL=web-client.js.map" >> /workspaces/ballerina-lang/web-client-deploy/web-client.js
