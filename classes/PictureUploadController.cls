public with sharing class PictureUploadController {
    @AuraEnabled
    public static string returnPhotoURL(Id userId){
        try {

            ContentDocumentLink cdl = [SELECT 
                Id, 
                ContentDocumentId 
                FROM ContentDocumentLink 
                WHERE LinkedEntityId  =:userId
            ];

            ContentVersion cv = [SELECT 
                Id,
                FileExtension,
                Title,
                CreatedDate
                FROM ContentVersion 
                WHERE ContentDocumentId = :cdl.ContentDocumentId
            ];

            return '/sfc/servlet.shepherd/version/download/' + cv.Id; 
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void changeFileName(Id cvId, Id cdId, String fileName){
        try {
            List<String> listStr = new List<String>{'jpg', 'jpeg', 'png'};

            ContentVersion uploadedFile = [SELECT 
                FirstPublishLocationId
                FROM ContentVersion
                WHERE Id =: cvId
            ];

            List<ContentDocument> listCD = [SELECT 
                Id, 
                FileType, 
                FileExtension,
                OwnerId,
                Title 
                FROM ContentDocument
                WHERE FileExtension 
                IN :listStr
            ];            
        
            for (ContentDocument cd : listCD) {
                if (cd.Id == cdId) {
                    cd.Title = fileName;
                    update cd; 
                }

                ContentVersion oldFile = [SELECT 
                    FirstPublishLocationId
                    FROM ContentVersion
                    WHERE ContentDocumentId =: cd.Id
                ];

                if (cd.Title.contains('_avatar') && cd.Id != cdId && oldFile.FirstPublishLocationId == uploadedFile.FirstPublishLocationId) {
                    delete cd;
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
