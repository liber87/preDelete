//<?php
/**
 * preDelete
 *
 * Контролируем удаление документов
 *
 * @category    plugin
 * @internal    @events OnBeforeEmptyTrash,OnManagerTreePrerender,OnPageNotFound
 * @internal    @modx_category Manager and Admin
 * @internal    @properties 
 * @internal    @disabled 0
 * @internal    @installset base
 */
if ($modx->Event->name=='OnManagerTreePrerender')
{
$out.="
<script>	
	modx.tree.emptyTrash = function()
	{	
		window.open('./../emptyTrash', 'main');	 
	}
</script>";
	$modx->Event->output($out);
}
if ($modx->Event->name=='OnBeforeEmptyTrash') exit();
if ($modx->Event->name=='OnPageNotFound')
{
	
	if ($_REQUEST['q']!='emptyTrash') return;	
	if(!$modx->hasPermission('delete_document')) {
		$modx->webAlertAndQuit($_lang["error_no_privileges"]);
	}
		
	
	if ($_POST['act'])
	{		
		if ($_POST['act']==2)
		{
			$ids = ' and site_content.id in ('.implode(',',$_POST['deleted']).') ';		
			$ids2 = ' and id in ('.implode(',',$_POST['deleted']).') ';		
			
		}
		$sql = "DELETE document_groups
		FROM ".$modx->getFullTableName('document_groups')." AS document_groups
		INNER JOIN ".$modx->getFullTableName('site_content')." AS site_content ON site_content.id = document_groups.document
		WHERE site_content.deleted=1".$ids;
		$modx->db->query($sql);

		
		$sql = "DELETE site_tmplvar_contentvalues
				FROM ".$modx->getFullTableName('site_tmplvar_contentvalues')." AS site_tmplvar_contentvalues
				INNER JOIN ".$modx->getFullTableName('site_content')." AS site_content ON site_content.id = site_tmplvar_contentvalues.contentid
				WHERE site_content.deleted=1".$id;
		$modx->db->query($sql);

		//'undelete' the document.
		$modx->db->delete($modx->getFullTableName('site_content'), "deleted=1".$ids2);
	}

	
	
	
	if (!$_GET['page']) $p=0;
	else $p = $_GET['page']*100;
	$count = $modx->db->getValue('Select count(*) from '.$modx->getFullTableName('site_content').' where deleted=1');
?>
	<!DOCTYPE html>
	<html>
	<head>
		<link rel="stylesheet" type="text/css" href="/<?=MGR_DIR;?>/media/style/<?=$modx->config['manager_theme'];?>/style.css" /> 
		
		<script>
			function set_chk()
			{
				var c = document.getElementById('title_cheched').checked;
				var chks = document.querySelectorAll('.chk');
				[].forEach.call(chks, el => {
				el.checked = chks;
				});				
			}	
		</script>
	</head>
	<body>
	<div class="table-responsive" style="padding:20px;"><h2>Удаление доументов <small>(<?=$count;?>)</small></h2>
	<?php
	if ($count==0) die('Все элементы были успешно удалены!');
	?>
		<div id="actions">
			<ul class="actionButtons">			
				<li ><a href="javascript:document.getElementById('act').value=2; document.forms['form'].submit();" id="Button1">Удалить выбранные</a></li>			
				<li ><a href="javascript:document.forms['form'].submit()" id="Button2">Удалить ВСЕ</a></li>			
			</ul>
		</div>
	
	<form action="" method="post" id="form">
	<input type="hidden" name="act" id="act" value="1">	
	<table class="table data" cellpadding="1" cellspacing="1">
	<tr>
	<td style="width:30px;"><input type="checkbox" onclick="set_chk();" id="title_cheched"></td>
	<td>ID</td>
	<td>Родитель</td>
	<td>Название</td>
	<td>Когда</td>
	<td>Кем</td>
	</tr>
<?		
	$res = $modx->db->query('SELECT c1.`id`,c1.`pagetitle`,c1.`deletedon`,c1.`deletedby`,c2.`pagetitle` as `papa`,`username` 
							FROM '.$modx->getFullTableName('site_content').' as `c1`
							left join '.$modx->getFullTableName('site_content').' as `c2`
							on c1.parent = c2.id 
							left join '.$modx->getFullTableName('manager_users').' as u
                            on c1.`deletedby` = u.id
							where c1.deleted=1 limit '.$p.',100');
	while ($row = $modx->db->getRow($res))
	{
		$row['deletedon'] = date('d-m-Y H:i:s',$row['deletedon']);		
		echo '<tr>
		<td><input type="checkbox" name="deleted[]" value="'.$row['id'].'" class="chk"></td>
		<td>'.$row['id'].'</td>
		<td>'.$row['papa'].'</td>
		<td>'.$row['pagetitle'].'</td>
		<td>'.$row['deletedon'].'</td>
		<td>'.$row['username'].'</td>
		</tr>';
	}
	echo '</table></form>';
	if ($count>100)
	{
		echo '<div id="pagination" class="paginate">Перейти на<ul>';
		for($i=1;$i<ceil($count/100);$i++) echo '<li><a href="emptyTrash?page='.$i.'">'.$i.'</a></li>';
		echo '</ul></div>';
	}
	echo '</div></body></html>';
	exit();
}
