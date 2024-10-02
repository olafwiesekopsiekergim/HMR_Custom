permissionset 51005 HMR_Custom
{
    Assignable = true;
    Permissions = tabledata gimBitmap=RIMD,
        tabledata gimMaterialShortage=RIMD,
        table gimBitmap=X,
        table gimMaterialShortage=X,
        codeunit gimHMREvents=X,
        codeunit gimLightManagement=X,
        codeunit gimMaterialShortageMgmt=X,
        codeunit gimProdOrderManagement=X,
        page gimBipmapList=X,
        page gimMaterialShortageList=X;
}