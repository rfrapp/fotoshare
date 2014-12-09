// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require_tree .

$(document).ready(function() 
{
	$("#navbarInput-01").focusin(function() 
	{
		console.log("here focus");
		$(this).addClass("focus");
		$(this).animate({ width: '300px' }, 500);
	});

	$("#navbarInput-01").focusout(function() 
	{
		console.log("here");
		$(this).removeClass("focus");
		$(this).addClass("notfocus");
		$(this).animate({ width: '200px' }, 500);
	});
});
