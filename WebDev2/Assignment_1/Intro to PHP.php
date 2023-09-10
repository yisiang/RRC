<?php

/*******w********

    Name: Yi Siang Chang
    Date: 2023-09-06
    Description: Assignment1

****************/

$config = [
    'gallery_name' => 'Taiwan Gallery',
    'unsplash_access_key' => '3DdxMnPv0OFGbEaXogpnUAvCzThwL4bd7gscAeYoODA',
    'unsplash_categories' => ['nature','food','architecture','city/county'],
    // 'local_images' => ['array','of','local','image','filenames']
    'local_images' => [
	    ['filename' => 'Jiufen1230px.jpg', 'photographer' => 'Danielle Hoang', 'unsplash_url' => 'https://unsplash.com/@dani_h'],
	    ['filename' => 'LibertySquare1230px.jpg', 'photographer' => 'Nadine Marfurt
', 'unsplash_url' => 'https://unsplash.com/@nadine3'],
	    ['filename' => 'Taipei101_1230px.jpg', 'photographer' => 'Timo Volz', 'unsplash_url' => 'https://unsplash.com/@magict1911'],
	    ['filename' => 'TrainInTaitung1230px.jpg', 'photographer' => 'Instagram gary_outdoor', 'unsplash_url' => 'https://unsplash.com/@instagramgary_outdoor']
    ]


];


?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $config['gallery_name']; ?></title>
    <link rel="stylesheet" href="main.css">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/magnific-popup.js/1.1.0/magnific-popup.min.css">

    <!-- Luminous CSS and JavaScript links -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/luminous-lightbox/2.0.1/luminous-basic.min.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/luminous-lightbox/2.0.1/Luminous.min.js"></script>

</head>
<body>
    <!-- Remember that alternative syntax is good and html inside php is bad -->

    <h1><?php echo $config['gallery_name']; ?></h1>

    <!-- Display Unsplash images -->
    <?php foreach ($config['unsplash_categories'] as $category): ?>
        <h2><?php echo ucfirst($category); ?></h2>
	    <?php
	    // Generate Unsplash image URL for the category
	    $imageUrl = "https://source.unsplash.com/300x200/?$category";?>

	    <!--<img src="<?php /*echo $imageUrl; */?>" alt="<?php /*echo $category; */?> image">-->
        <a href="<?php echo $imageUrl; ?>" class="image-link" title="<?php echo ucfirst($category); ?> image">
            <img src="<?php echo $imageUrl; ?>" alt="<?php echo ucfirst($category); ?> image">
        </a>

    <?php endforeach; ?>

    <!-- Display locally stored images with thumbnails and lightbox links -->
    <h1><?php echo count($config['local_images']); ?> Large Images</h1>

    <div class="image-gallery">
	    <?php foreach ($config['local_images'] as $image): ?>
            <div class="image">
                <a href="<?php echo 'images/' . $image['filename']; ?>" class="image-link" title="Image by <?php echo $image['photographer']; ?>">
                    <img src="<?php echo 'images/' . $image['filename']; ?>" alt="Image by <?php echo $image['photographer']; ?>">
                </a>
                <p><a href="<?php echo $image['unsplash_url']; ?>" target="_blank"><?php echo $image['photographer']; ?></a></p>
            </div>
	    <?php endforeach; ?>
    </div>

    <!-- Initialize LuminousGallery for lightbox -->
    <script>
        new LuminousGallery(document.querySelectorAll(".image a"));
    </script>


</body>
</html>