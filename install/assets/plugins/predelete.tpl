//<?php
/**
 * preDelete
 *
 * Выбор удаляемых элементов
 *
 * @category    plugin
 * @internal    @events OnManagerTreeRender
 * @internal    @modx_category Manager and Admin
 * @internal    @properties {
  "modal": [
    {
      "label": "Use modal",
      "type": "list",
      "value": "yes",
      "options": "yes,no",
      "default": "yes",
      "desc": ""
    }
  ]
}
 * @internal    @disabled 0
 * @internal    @installset base
 */
return require MODX_BASE_PATH . 'assets/plugins/preDelete/plugin.preDelete.php';
