#!/usr/bin/env python
# This script needs these things to run:
# - pip install google-api-python-client oauth2client
# - service-account-private-key.json

"""Releases a built bundle to the Beta track."""

import httplib2

from googleapiclient.discovery import build
from oauth2client.service_account import ServiceAccountCredentials

PACKAGE_NAME = 'io.splits'
SCOPES = ['https://www.googleapis.com/auth/androidpublisher']
SERVICE_ACCOUNT_FILE = 'service-account-private-key.json'

BUNDLE_FILE = './build/app/outputs/bundle/release/app-release.aab'


def main():
    credentials = ServiceAccountCredentials.from_json_keyfile_name(
        SERVICE_ACCOUNT_FILE, scopes=SCOPES
    )

    http = httplib2.Http()
    http = credentials.authorize(http)

    service = build('androidpublisher', 'v3', http=http)

    edit_request = service.edits().insert(body={}, packageName=PACKAGE_NAME)
    result = edit_request.execute()
    edit_id = result['id']

    print('Uploading bundle ', BUNDLE_FILE)
    upload_bundle_result = service.edits().bundles().upload(
        editId=edit_id,
        media_body=BUNDLE_FILE,
        media_mime_type='application/octet-stream',
        packageName=PACKAGE_NAME,
    ).execute()
    print('Result: ', upload_bundle_result)


if __name__ == '__main__':
    main()
