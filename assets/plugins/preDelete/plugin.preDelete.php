<?php
if (!$_SESSION['mgrRole']) return;

if ($modal=='yes')
$SCRIPT .= <<<console
if (typeof modx.popup == 'function') {
	
	modx.tree.emptyTrash = function(){	
		modx.popup({url: '../assets/plugins/preDelete/preDelete.php',icon: 'fa-code',title: 'Удаление документов', draggable: true,'width': '90%','height':'90%','hide': 0,'hover': 0});
	}			
} else {
	modx.tree.emptyTrash = function(){	window.open('../assets/plugins/preDelete/preDelete.php','gener','width=800,height=560,top='+((screen.height-600)/2)+',left='+((screen.width-800)/2)+',toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no');
	};		
}
console;

if ($modal=='no')
$SCRIPT .= <<<console
if (typeof modx.tabs == 'function') {
	modx.tree.emptyTrash = function(){
		modx.tabs({url: '../assets/plugins/preDelete/preDelete.php', title: 'Удаление документов'});
	};	
} else {
	modx.tree.emptyTrash = function(){
		top.main.location.href='../assets/plugins/preDelete/preDelete.php'
	});
}
console;
$modx->event->setOutput('<script>'.$SCRIPT.'</script>');  