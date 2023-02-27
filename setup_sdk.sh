#!/bin/bash

set -e
testDir="ruby-sdk-test"
GREEN="\033[0;32m"
NC="\033[0m"

if [ ! $PLIVO_API_PROD_HOST ] || [ ! $PLIVO_API_DEV_HOST ] || [ ! $PLIVO_AUTH_ID ] || [ ! $PLIVO_AUTH_TOKEN ]; then
    echo "Environment variables not properly set! Please refer to Local Development section in README!"
    exit 126
fi

cd /usr/src/app

echo "Setting plivo-api endpoint to dev..."
find /usr/src/app/lib/ -type f -exec sed -i "s/$PLIVO_API_PROD_HOST/$PLIVO_API_DEV_HOST/g" {} \;

bundle install

if [ ! -d $testDir ]; then
    echo "Creating test dir..."
    mkdir -p $testDir
fi

if [ ! -f $testDir/test.rb ]; then
    echo "Creating test file..."
    cd $testDir
    echo -e "require \"rubygems\"" > test.rb
    echo -e "require \"/usr/src/app/lib/plivo.rb\"" >> test.rb
    echo -e "include Plivo\n" >> test.rb
    echo -e "api = RestClient.new(ENV[\"PLIVO_AUTH_ID\"], ENV[\"PLIVO_AUTH_TOKEN\"])" >> test.rb
    cd -
fi

echo -e "\n\nSDK setup complete!"
echo "To test your changes:"
echo -e "\t1. Add your test code in <path_to_cloned_sdk>/$testDir/test.rb on host (or /usr/src/app/$testDir/test.rb in the container)"
echo -e "\t\tNote: To use sdk in test file, import using $GREEN require \"/usr/src/app/lib/plivo.rb\"$NC"
echo -e "\t2. Run a terminal in the container using: $GREEN docker exec -it $HOSTNAME /bin/bash$NC"
echo -e "\t3. Navigate to the test directory: $GREEN cd /usr/src/app/$testDir$NC"
echo -e "\t4. Run your test file: $GREEN ruby test.rb$NC"
echo -e "\t5. For running unit tests, run on host: $GREEN make test CONTAINER=$HOSTNAME$NC"

# To keep the container running post setup
/bin/bash