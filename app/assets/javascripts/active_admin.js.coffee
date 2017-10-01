#= require active_admin/base
#= require cropper/cropper

$(document).ready () ->
  images = Array.from(document.getElementsByClassName('cropper-image'));

  images.forEach (image) ->
    cropper = new Cropper(image, {
      checkImageOrigin: false,
      checkCrossOrigin: false,
      minContainerWidth: 1000,
      minContainerHeight: 800,
      viewMode: 1,
      crop: (e) ->
        $('#crop_top_left_x').val(e.detail.x)
        $('#crop_top_left_y').val(e.detail.y)
        $('#crop_bottom_right_x').val(e.detail.x + e.detail.width)
        $('#crop_bottom_right_y').val(e.detail.y + e.detail.height)
    });

  $('#save_crop_values').click (e) ->
    $('#image_crop_top_left_x').val($('#crop_top_left_x').val())
    $('#image_crop_top_left_y').val($('#crop_top_left_y').val())
    $('#image_crop_bottom_right_x').val($('#crop_bottom_right_x').val())
    $('#image_crop_bottom_right_y').val($('#crop_bottom_right_y').val())

    $('#image_custom_cropping').attr('checked', 'checked')
