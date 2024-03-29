set -e

# Initialize the root CA
fabric-ca-server init -b $BOOTSTRAP_USER_PASS

# Copy the root CA's signing certificate to the data directory to be used by others
mkdir -p $TARGET
cp $FABRIC_CA_SERVER_HOME/ca-cert.pem $TARGET_CERTFILE
cp -r $TARGET $TLSTARGET
# Add the custom orgs
for o in $FABRIC_ORGS; do
   aff=$aff"\n   $o: []"
done
aff="${aff#\\n   }"
sed -i "/affiliations:/a \\   $aff" \
   $FABRIC_CA_SERVER_HOME/fabric-ca-server-config.yaml

# Start the root CA
fabric-ca-server start
