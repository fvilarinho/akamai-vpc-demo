# Create the credentials to store terraform state in the Akamai Connected Cloud object storage.
function createTerraformStateCredentials() {
  mkdir -p ~/.aws 2> /dev/null

  echo "[default]" > ~/.aws/credentials
  echo "aws_access_key_id = $LINODE_OBJECT_STORAGE_ACCESS_KEY" >> ~/.aws/credentials
  echo "aws_secret_access_key = $LINODE_OBJECT_STORAGE_ACCESS_SECRET" >> ~/.aws/credentials
}