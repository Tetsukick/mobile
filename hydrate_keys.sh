echo $ANDROID_KEY_BASE64 | base64 --decode > android/app/$ANDROID_KEYSTORE_PATH
echo $GOOGLE_SERVICE_ACCOUNT_PRIVATE_KEY | base64 --decode > service-account-private-key.json
