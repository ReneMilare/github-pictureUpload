import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import returnPhotoURL from '@salesforce/apex/PictureUploadController.returnPhotoURL';
import changeFileName from '@salesforce/apex/PictureUploadController.changeFileName';

export default class PictureUpload extends LightningElement {
  @api recordId;
  publicURL;
  documentId;
  documentName;
  contentVersionId;
  splitName;
  imgExist = false;

  get acceptedFormats(){
    return ['.png', '.jpg', '.jpeg'];
  }

  connectedCallback(){
    this.showCurrentImage();
  }

  handleUploadFinished(event) {

    const uploadedFiles = event.detail.files;
    
    for (let i = 0; i < uploadedFiles.length; i++) {
      this.splitName = uploadedFiles[i].name.split('.')
      console.log(this.splitName);
      this.documentName = this.splitName[0] + '_avatar';
      this.documentId = uploadedFiles[i].documentId;
      this.contentVersionId = uploadedFiles[i].contentVersionId;
    }
    
    this.dispatchEvent(
      new ShowToastEvent({
        title: "Success",
        message: 'Imagem importada com sucesso',
        variant: "success",
      })
    );

    this.publicURL = '/sfc/servlet.shepherd/version/download/' + this.contentVersionId;

    changeFileName({
      cvId: this.contentVersionId,
      cdId: this.documentId,
      fileName: this.documentName
    });

    // this.showCurrentImage();
  }

  showCurrentImage(){
    returnPhotoURL({
      userId: this.recordId
    }).then(retorno=>{
      this.imgExist = true;
      this.publicURL = retorno;
    }).catch(error =>{
      console.log('error: ' + error.body.message);
    });
  }
}