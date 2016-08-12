$(document).ready(function(){
	resetTagsField();
});


function ShowHideCreateAlbum(visible)
{
	if (visible)
      {
        $("#createNewAlbum").show();
        $("#updateAlbum").hide();
        $("#uploadNewPhoto").hide();
        $("#updatePicture").hide();
      }
      else
      {
        $("#createNewAlbum").hide();
      }
}
function ShowHideUploadPhoto(visible)
{
  if (visible)
      {
        $("#uploadNewPhoto").show();
        $("#createNewAlbum").hide();
        $("#updateAlbum").hide();
        $("#updatePicture").hide();
      }
      else
      {
        $("#uploadNewPhoto").hide();
      }
}

function ShowHideEditAlbum(visible)
{
  if (visible)
      {
        $("#updateAlbum").show();
        $("#uploadNewPhoto").hide();
        $("#createNewAlbum").hide();
        $("#updatePicture").hide();
      }
      else
      {
        $("#updateAlbum").hide();
      }
}
function ShowHideEditPicture(visible)
{
  if (visible)
      {
        $("#updatePicture").show();
        $("#updateAlbum").hide();
        $("#uploadNewPhoto").hide();
        $("#createNewAlbum").hide();
      }
      else
      {
        $("#updatePicture").hide();
      }
}

function resetTagsField()
{
	$('.chips').material_chip();
    $('.photoalbumChips').html("<input class='input' placeholder='' name='photoalbum[tag]' id='photoalbum_tag' onfocus='SetActiveLabelAlbum();' onfocusout='SetInActiveLabelAlbum()'><label for='photoalbum_tag' id='album_tag_label'>Want to add any tags to your album?</label>");

    $('.editPhotoalbumChips').html("<input class='input' placeholder='' name='picture[tag]' id='picture_tag' onfocus='SetActiveLabelPhoto();' onfocusout='SetInActiveLabelPhoto()'><label for='picture_tag' id='picture_tag_label'>Want to add any tags to your album?</label>");

    $('.photoChips').html("<input class='input' placeholder='' name='picture[tag]' id='picture_tag' onfocus='SetActiveLabelPhoto();' onfocusout='SetInActiveLabelPhoto()'><label for='picture_tag' id='picture_tag_label'>Want to add any tags to your picture?</label>");

}

function GetChipsData()
{
	return JSON.stringify($('.chips').material_chip('data'));
}
function SetActiveLabelAlbum()
{
	document.getElementById("album_tag_label").className = " active";
}
function SetActiveLabelPhoto()
{
  document.getElementById("picture_tag_label").className = " active";
}
function SetInActiveLabelAlbum()
{
	if ($('.photoalbumChips').length > 2)
    	document.getElementById("album_tag_label").className = " active";
	else
    	document.getElementById("album_tag_label").className = "";
}
function SetInActiveLabelPhoto()
{
  if ($('.photoChips').length > 2)
      document.getElementById("picture_tag_label").className = " active";
  else
      document.getElementById("picture_tag_label").className = "";
}
