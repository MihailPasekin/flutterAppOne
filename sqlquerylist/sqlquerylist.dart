String createQueueTable =
    'CREATE TABLE "queue" ("id"	INTEGER UNIQUE,"api"	TEXT,	"body"	TEXT,	"createdDateTime"	TEXT,	"sent"	TEXT,	"sentDateTime"	TEXT,	PRIMARY KEY("id" AUTOINCREMENT));';
String createUserTable =
    'CREATE TABLE "user" ("id"	INTEGER UNIQUE,"empId"	INTEGER,"firstName"	TEXT,"lastName"	TEXT,"middleName"	TEXT,"sex"	TEXT,	"jobTitle"	TEXT,	"dept"	INTEGER,	"birthDay"	TEXT,	"mobile"	TEXT,	"homeTel"	TEXT,	"email"	TEXT,	"workStreet"	TEXT,	"workCity"	TEXT,	"password"	TEXT,	"password2"	TEXT,	"photo"	TEXT,	PRIMARY KEY("id" AUTOINCREMENT));';
String createCustomerTable =
    'CREATE TABLE "customer" (	"id"	INTEGER UNIQUE,	"CardCode"	TEXT,	"CardName"	TEXT,	"Phone1"	TEXT,	"Free_Text"	TEXT,	"Notes"	TEXT,	"U_lat"	TEXT,	"U_lng"	TEXT,	PRIMARY KEY("id" AUTOINCREMENT));';
String createItemTable =
    'CREATE TABLE "item" ("id"	INTEGER UNIQUE,	"ItemCode"	TEXT,	"ItemName"	TEXT,	"Price"	TEXT,	"WhsName"	TEXT,	"ItemCount"	TEXT,	"PicturName" TEXT, "LocalPicturName"	TEXT, "ItmsGrpCod"	INTEGER, PRIMARY KEY("id" AUTOINCREMENT));';
String createParamTable =
    'CREATE TABLE "params" ("id"	INTEGER UNIQUE,	"paramName"	TEXT UNIQUE,	"intVal"	INTEGER,	"stringVal"	TEXT,	"dateTimeVal"	TEXT,	PRIMARY KEY("id" AUTOINCREMENT));';
String createOrderTable =
    'CREATE TABLE "order" (	"id"	INTEGER,	"docEntry"	INTEGER,	"docNum"	INTEGER,	"docStatus"	TEXT,	"docDate"	TEXT,	"cardCode"	TEXT,	"cardName"	TEXT,	"docTotal"	REAL,	"grosProfit"	REAL,	"ownerCode"	INTEGER,	"groupNum"	INTEGER,	"payType"	TEXT,	PRIMARY KEY("id" AUTOINCREMENT));';
String createDeliveryTable =
    'CREATE TABLE "delivery" (	"id"	INTEGER,	"docEntry"	INTEGER,	"docNum"	TEXT,	"docStatus"	TEXT,	"docDate"	TEXT,	"cardCode"	TEXT,	"cardName"	TEXT,	"docTotal"	TEXT, "payType"	TEXT,	PRIMARY KEY("docEntry" AUTOINCREMENT))';
String createDeliveryItemTable =
    'CREATE TABLE "deliveryItem" (	"id"	INTEGER,	"ItemCode"	TEXT,	"ItemName"	TEXT,	"Price"	TEXT,	"Quantity"	INTEGER,	"PicturName"	TEXT,	"DocNum"	INTEGER,	"BaseRef"	TEXT,	"BaseEntry"	INTEGER, "DocEntry"	INTEGER,	PRIMARY KEY("id" AUTOINCREMENT))';
String createMerchProducktGroupTable =
    'CREATE TABLE "merchProduktGroup" (	"MerchGroupId"	INTEGER,	"MerchGroupName"	TEXT,	"Description"	TEXT,	"Cod"	TEXT)';
String createMrechProduckt =
    'CREATE TABLE "merchproduct" (	"MerchProductId"	INTEGER,	"MerchProductGroupId"	INTEGER,	"MerchProductName"	TEXT)';
String createPlanMerchTable =
    'CREATE TABLE "planmerch" (	"PlanId"	INTEGER,	"EmpId"	INTEGER,	"PlanDate"	TEXT,	"CreatedAt"	TEXT,	"UpdatedAt"	TEXT,	"PlanStatus"	TEXT,	"Coment"	TEXT,	"CreatedUserId"	INTEGER,PRIMARY KEY("PlanId"));';
String createPalnDetailTable =
    'CREATE TABLE "plandetail" (	"PlanDetailId"	INTEGER,	"PlanId"	INTEGER,	"CastomerId"	INTEGER,	"PlanDeteilStatus"	TEXT,	"CreatedAt"	TEXT,	"UpdatedAt"	TEXT,	"CreatedUserId"	INTEGER,	"CardName"	TEXT,	"CardCode"	TEXT,	PRIMARY KEY("PlanDetailId"));';
String createPlanReportTable =
    'CREATE TABLE "planReport" ( "PlanReportId"	INTEGER,	"EmpId"	INTEGER,	"PlanId"	INTEGER,	"PlanDetailId"	INTEGER,	"CreatedAt"	TEXT,	PRIMARY KEY("PlanReportId" AUTOINCREMENT))';
String createPhotoBeforeTable =
    'CREATE TABLE "photoBefore" (	"PhotoId"	INTEGER,	"PlanId"	INTEGER,	"PlanDetailId"	INTEGER,	"CreatedAt"	TEXT,	"PhotoName"	TEXT,	"FullFileName"	TEXT, "Period" TEXT,	PRIMARY KEY("PhotoId" AUTOINCREMENT))';
String createPhotoAfterTable =
    'CREATE TABLE "photoAfter" (	"PhotoId"	INTEGER,	"PlanId"	INTEGER,	"PlanDetailId"	INTEGER,	"CreatedAt"	TEXT,	"PhotoName"	TEXT,	"FullFileName"	TEXT,	"Period" TEXT,  PRIMARY KEY("PhotoId" AUTOINCREMENT))';
String createTlemetryTable =
    'CREATE TABLE "telemetryy" (	"id"	INTEGER,	"empid"	INTEGER,	"longitude"	TEXT,	"latitude"	TEXT,	"createdate"	TEXT,	"batterylevel"	INTEGER,	"send"	TEXT,	"senddate"	TEXT,	PRIMARY KEY("id" AUTOINCREMENT));';
String createItemGroupTable =
    'CREATE TABLE "itemGroup" (	"ItmsGrpCod"	INTEGER,	"ItmsGrpNam"	TEXT);';
