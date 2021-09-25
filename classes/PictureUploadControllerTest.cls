@isTest
public with sharing class PictureUploadControllerTest {
    
    @isTest
    public static void returnURLPhoto(){

        String userId = '0055e0000062BUtAAM';

        //File 1
        ContentVersion cv1 = new ContentVersion(
            Title = 'isTest_avatar',
            PathOnClient = 'isTest_avatar.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );

        insert cv1;

        ContentVersion cvUploaded1 = [SELECT
            Id,
            Title
            FROM ContentVersion
            WHERE Title =: cv1.Title
        ];

        ContentDocument cdUploaded1 = [SELECT
            Id,
            Title
            FROM ContentDocument
            WHERE Title =: cv1.Title
        ];

        PictureUploadController.changeFileName(cvUploaded1.Id, cdUploaded1.Id, cdUploaded1.Title);

        //File 2
        ContentVersion cv2 = new ContentVersion(
            Title = 'isTest_avatar',
            PathOnClient = 'isTest_avatar.jpg',
            VersionData = Blob.valueOf('Test Content'),
            IsMajorVersion = true
        );

        insert cv2;

        List<ContentVersion> cvUploaded2 = [SELECT
            Id,
            Title
            FROM ContentVersion
            WHERE Title =: cv2.Title
        ];

        List<ContentDocument> cdUploaded2 = [SELECT
            Id,
            Title
            FROM ContentDocument
            WHERE Title =: cv2.Title
        ];

        PictureUploadController.changeFileName(cvUploaded2[1].Id, cdUploaded2[1].Id, cdUploaded2[1].Title);

        ContentDocument cd2 = [SELECT
            Id,
            Title
            FROM ContentDocument
            WHERE Title =: cv2.Title
        ];

        ContentDocumentLink cdl = [SELECT 
            Id, 
            ContentDocumentId,
            LinkedEntityId
            FROM ContentDocumentLink 
            WHERE ContentDocumentId  =:cd2.Id
        ];

        String url = PictureUploadController.returnPhotoURL(cdl.LinkedEntityId);

        String expectedReturn = '/sfc/servlet.shepherd/version/download/' + cvUploaded2[1].Id;

        System.assertEquals(expectedReturn, url);
    }

}