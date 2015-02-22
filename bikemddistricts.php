<?php

require_once 'bikemddistricts.civix.php';

/**
 * Implementation of hook_civicrm_buildForm
 * 
 * Figure out which version CiviCRM we are running and call correct handler
 */
function bikemddistricts_civicrm_buildForm($formName, &$form) {
    $version = CRM_Utils_System::version();
    //var_dump($version);
    
    if(startsWith($version, "4.5")){
        bikemddistricts_version45($formName, $form);
    } else if(startsWith($version, "4.4")){
        bikemddistricts_version44($formName, $form);
    }
}

function bikemddistricts_version44($formName, &$form) {
    // Does this form contain one of the district custom fields?  If so
    // add our template
    $gotSEN = $form->elementExists('custom_32');

    if ($gotSEN) {
        // Assumes templates are in a templates folder relative to this file
        $templatePath = realpath(dirname(__FILE__) . "/templates");
        CRM_Core_Region::instance('page-body')->add(array(
            'template' => "{$templatePath}/districts44.tpl"
        ));
    }
}


function bikemddistricts_version45($formName, &$form) {
    // Does this form contain one of the district custom fields?  If so
    // add our template
    $gotSEN = $form->elementExists('custom_1');

    if ($gotSEN) {
        // Assumes templates are in a templates folder relative to this file
        $templatePath = realpath(dirname(__FILE__) . "/templates");
        CRM_Core_Region::instance('page-body')->add(array(
            'template' => "{$templatePath}/districts45.tpl"
        ));
    }
}

/**
 * Implementation of hook_civicrm_config
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_config
 */
function bikemddistricts_civicrm_config(&$config) {
  _bikemddistricts_civix_civicrm_config($config);
}

/**
 * Implementation of hook_civicrm_xmlMenu
 *
 * @param $files array(string)
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_xmlMenu
 */
function bikemddistricts_civicrm_xmlMenu(&$files) {
  _bikemddistricts_civix_civicrm_xmlMenu($files);
}

/**
 * Implementation of hook_civicrm_install
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_install
 */
function bikemddistricts_civicrm_install() {
  _bikemddistricts_civix_civicrm_install();
}

/**
 * Implementation of hook_civicrm_uninstall
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_uninstall
 */
function bikemddistricts_civicrm_uninstall() {
  _bikemddistricts_civix_civicrm_uninstall();
}

/**
 * Implementation of hook_civicrm_enable
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_enable
 */
function bikemddistricts_civicrm_enable() {
  _bikemddistricts_civix_civicrm_enable();
}

/**
 * Implementation of hook_civicrm_disable
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_disable
 */
function bikemddistricts_civicrm_disable() {
  _bikemddistricts_civix_civicrm_disable();
}

/**
 * Implementation of hook_civicrm_upgrade
 *
 * @param $op string, the type of operation being performed; 'check' or 'enqueue'
 * @param $queue CRM_Queue_Queue, (for 'enqueue') the modifiable list of pending up upgrade tasks
 *
 * @return mixed  based on op. for 'check', returns array(boolean) (TRUE if upgrades are pending)
 *                for 'enqueue', returns void
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_upgrade
 */
function bikemddistricts_civicrm_upgrade($op, CRM_Queue_Queue $queue = NULL) {
  return _bikemddistricts_civix_civicrm_upgrade($op, $queue);
}

/**
 * Implementation of hook_civicrm_managed
 *
 * Generate a list of entities to create/deactivate/delete when this module
 * is installed, disabled, uninstalled.
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_managed
 */
function bikemddistricts_civicrm_managed(&$entities) {
  _bikemddistricts_civix_civicrm_managed($entities);
}

/**
 * Implementation of hook_civicrm_caseTypes
 *
 * Generate a list of case-types
 *
 * Note: This hook only runs in CiviCRM 4.4+.
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_caseTypes
 */
function bikemddistricts_civicrm_caseTypes(&$caseTypes) {
  _bikemddistricts_civix_civicrm_caseTypes($caseTypes);
}

/**
 * Implementation of hook_civicrm_alterSettingsFolders
 *
 * @link http://wiki.civicrm.org/confluence/display/CRMDOC/hook_civicrm_alterSettingsFolders
 */
function bikemddistricts_civicrm_alterSettingsFolders(&$metaDataFolders = NULL) {
  _bikemddistricts_civix_civicrm_alterSettingsFolders($metaDataFolders);
}

function startsWith($haystack, $needle) {
    // search backwards starting from haystack length characters from the end
    return $needle === "" || strrpos($haystack, $needle, -strlen($haystack)) !== FALSE;
}