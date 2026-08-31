-- TCRMHC Phase 14: Zaghloul WhatsApp CRM, Automation & AI V14.0
-- Grounded in apps/zaghloul-wacrm from TCRM main.
-- Covers dashboard, realtime inbox, contacts, broadcasts, automations,
-- flows, pipelines/deals, AI agents, and WhatsApp Cloud configuration.

BEGIN;

DO $$
DECLARE
  owner_tenant UUID;
  v_module_id UUID;
  v_category_id UUID;
  v_subcategory_id UUID;
  published_count INTEGER;
BEGIN
  SELECT id, tenant_id
  INTO v_module_id, owner_tenant
  FROM kb_modules
  WHERE slug = 'tcrm'
    AND status = 'active'
  ORDER BY created_at, id
  LIMIT 1;

  IF v_module_id IS NULL OR owner_tenant IS NULL THEN
    RAISE EXCEPTION 'TCRMHC_PHASE14_REQUIRES_TCRM_MODULE';
  END IF;

  SELECT id
  INTO v_category_id
  FROM kb_categories
  WHERE tenant_id = owner_tenant
    AND module_id = v_module_id
    AND slug = 'tcrm-ai-staff'
    AND status = 'active'
  ORDER BY created_at, id
  LIMIT 1;

  IF v_category_id IS NULL THEN
    RAISE EXCEPTION 'TCRMHC_PHASE14_REQUIRES_AI_STAFF_CATEGORY';
  END IF;

  INSERT INTO kb_subcategories (
    tenant_id, category_id, title_ar, title_en, slug,
    description_ar, description_en, status, sort_order
  ) VALUES (
    owner_tenant,
    v_category_id,
    'Zaghloul - واتساب CRM والأتمتة',
    'Zaghloul - WhatsApp CRM & Automation',
    'tcrm-zaghloul-wacrm',
    'دليل عملي لاستخدام Zaghloul في إدارة محادثات واتساب والعملاء والحملات والأتمتة والـFlows والصفقات وAI Agents.',
    'Practical guide to using Zaghloul for WhatsApp conversations, contacts, broadcasts, automation, flows, deals, and AI agents.',
    'active',
    75
  ) ON CONFLICT (tenant_id, slug) DO UPDATE
  SET category_id = EXCLUDED.category_id,
      title_ar = EXCLUDED.title_ar,
      title_en = EXCLUDED.title_en,
      description_ar = EXCLUDED.description_ar,
      description_en = EXCLUDED.description_en,
      status = EXCLUDED.status,
      sort_order = EXCLUDED.sort_order,
      updated_at = NOW()
  RETURNING id INTO v_subcategory_id;

  INSERT INTO kb_articles (
    tenant_id,module_id,category_id,subcategory_id,slug,title_ar,title_en,excerpt_ar,excerpt_en,
    body_ar,body_en,status,sort_order,seo_title_ar,seo_title_en,seo_description_ar,seo_description_en,
    published_at,visibility_scope,consumer_hidden,canonical_article_id,media
  ) VALUES
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,'tcrm-ai-staff-zaghloul',
    'استخدام Zaghloul كمنصة WhatsApp CRM متكاملة','Using Zaghloul as an Integrated WhatsApp CRM',
    'تعرّف على لوحة Zaghloul ووظائفها الأساسية لإدارة المحادثات والعملاء والصفقات والحملات والأتمتة.',
    'Learn the Zaghloul dashboard and its core workflows for conversations, contacts, deals, broadcasts, and automation.',
    $ar$Zaghloul في TCRM ليس مجرد اسم ضمن AI Staff؛ التطبيق الحالي يوفر مساحة WhatsApp CRM متكاملة لإدارة التواصل والعمليات المرتبطة به.

لوحة التحكم تعرض أهم المؤشرات التشغيلية:
• Active Conversations: المحادثات النشطة.
• New Contacts Today: جهات الاتصال الجديدة اليوم.
• Open Deals Value: قيمة الصفقات المفتوحة مع عددها.
• Messages Sent Today: الرسائل المرسلة اليوم.

كما تعرض اللوحة:
• اتجاه المحادثات لفترات 7 أو 30 أو 90 يومًا.
• توزيع الـPipeline.
• Response Time.
• Activity Feed.
• Quick Actions للوصول السريع للعمليات المتكررة.

المسار اليومي المقترح:
1. ابدأ من Dashboard لمراجعة النشاط والأداء.
2. انتقل إلى Inbox لمتابعة المحادثات الحالية.
3. استخدم Contacts لتنظيم بيانات العملاء والتصنيفات.
4. استخدم Pipelines لمتابعة الفرص والصفقات.
5. استخدم Broadcasts للحملات الجماعية المعتمدة على Templates.
6. استخدم Automations وFlows لتقليل الخطوات اليدوية.
7. استخدم AI Agents بعد إعدادها واختبارها في Playground.

تختلف بعض إجراءات الإنشاء والإعداد حسب صلاحية المستخدم، لذلك قد تظهر الواجهة نفسها مع إجراءات أقل لبعض الأدوار.$ar$,
    $en$Zaghloul in TCRM is more than an AI Staff name. The current application provides an integrated WhatsApp CRM workspace for communication and related operations.

The dashboard exposes key operational indicators:
• Active Conversations.
• New Contacts Today.
• Open Deals Value together with the number of open deals.
• Messages Sent Today.

It also includes:
• Conversation trends for 7, 30, or 90 days.
• Pipeline distribution.
• Response Time.
• Activity Feed.
• Quick Actions for common workflows.

Recommended daily workflow:
1. Start with the Dashboard to review activity and performance.
2. Move to Inbox for active customer conversations.
3. Use Contacts to organize customer data and tags.
4. Use Pipelines to track opportunities and deals.
5. Use Broadcasts for template-based bulk campaigns.
6. Use Automations and Flows to reduce manual work.
7. Use AI Agents after configuration and Playground testing.

Some creation and configuration actions are permission-gated, so different roles can see the same workspace with different available actions.$en$,
    'published',75,
    'استخدام Zaghloul كمنصة WhatsApp CRM متكاملة','Using Zaghloul as an Integrated WhatsApp CRM',
    'دليل لوحة Zaghloul ومسارات المحادثات والعملاء والصفقات والحملات والأتمتة.',
    'Guide to the Zaghloul dashboard and its conversation, contact, deal, broadcast, and automation workflows.',
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,'tcrm-zaghloul-inbox-realtime',
    'إدارة المحادثات من Zaghloul Inbox','Managing Conversations in the Zaghloul Inbox',
    'استخدم صندوق الوارد اللحظي لمتابعة الرسائل والمحادثات وبيانات العميل من مساحة واحدة.',
    'Use the realtime inbox to manage messages, conversations, and contact context from one workspace.',
    $ar$Inbox في Zaghloul هو مركز العمل اليومي للمحادثات.

أهم الوظائف:
• قائمة محادثات يمكن الانتقال بينها بسرعة.
• عرض Thread الرسائل للمحادثة المحددة.
• Contact Sidebar لعرض سياق العميل مثل Tags وDeals وNotes.
• دعم فتح محادثة محددة مباشرة من رابط يحتوي على Conversation ID.
• تحديثات Realtime للرسائل وحالة المحادثة.
• عداد Unread يتم تحديثه مع وصول الرسائل.

الاستمرارية عند انقطاع الاتصال:
Zaghloul لا يعتمد فقط على حدث Realtime واحد. عند عودة الاتصال أو رجوع المستخدم إلى التبويب، يتم تشغيل مزامنة جديدة لتقليل احتمال فقد تحديثات تمت أثناء الانقطاع أو أثناء وجود التبويب في الخلفية. يوجد أيضًا Refresh يدوي للمحادثة.

حالة WhatsApp:
يتحقق Inbox من وجود اتصال WhatsApp للحساب الحالي. إذا لم يكن الحساب متصلًا، يظهر للمستخدم تنبيه بدل افتراض أن الرسائل ستعمل بصورة طبيعية.

أفضل ممارسة:
عند فتح محادثة، راجع سياق العميل في اللوحة الجانبية قبل الرد، ثم حدّث الحالة أو البيانات المرتبطة بالعميل عند الحاجة.$ar$,
    $en$The Zaghloul Inbox is the main daily workspace for conversations.

Core capabilities include:
• A conversation list for fast switching.
• The message thread for the selected conversation.
• A Contact Sidebar with customer context such as tags, deals, and notes.
• Deep-link support for opening a specific conversation by Conversation ID.
• Realtime updates for messages and conversation state.
• Unread counts that update as messages arrive.

Continuity after connection loss:
Zaghloul does not rely on a single realtime event path. When the realtime connection returns or the browser tab becomes visible again, the inbox triggers a resynchronization to reduce the chance of missing changes that happened while disconnected or backgrounded. A manual refresh path is also available.

WhatsApp state:
The Inbox checks the WhatsApp connection for the current account. When no active connection is found, the user is warned instead of the interface assuming messaging is available.

Best practice:
Before replying, review the contact context in the sidebar, then update the customer-related state when needed.$en$,
    'published',80,
    'إدارة المحادثات من Zaghloul Inbox','Managing Conversations in the Zaghloul Inbox',
    'شرح Inbox اللحظي والمحادثات وبيانات العميل وإعادة المزامنة في Zaghloul.',
    'Guide to the realtime inbox, conversation context, and resynchronization behavior in Zaghloul.',
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,'tcrm-zaghloul-contacts',
    'إدارة Contacts والتصنيفات والاستيراد في Zaghloul','Managing Contacts, Tags, and Imports in Zaghloul',
    'أضف وابحث وصنّف واستورد جهات الاتصال، واستخدم Custom Fields لتنظيم بيانات العملاء.',
    'Add, search, tag, import, and organize contacts with custom fields.',
    $ar$صفحة Contacts تجمع إدارة قاعدة العملاء في مكان واحد.

البحث والتصفية:
• البحث يدعم الاسم ورقم الهاتف والبريد الإلكتروني.
• يمكن التصفية باستخدام Tag واحد أو أكثر.
• عند اختيار أكثر من Tag، تُرجع التصفية جهات الاتصال التي تحمل أيًا من الـTags المختارة.
• النتائج مقسمة إلى صفحات، مع 25 جهة اتصال في الصفحة.

إدارة البيانات:
• Add Contact لإضافة جهة اتصال جديدة.
• Edit لتعديل البيانات الحالية.
• Contact Detail لعرض تفاصيل العميل.
• Import لاستيراد جهات اتصال جديدة.
• Custom Fields لإضافة حقول مناسبة لاحتياجات العمل.

الإجراءات الجماعية:
يمكن تحديد جهات الاتصال الظاهرة في الصفحة الحالية وتنفيذ Bulk Delete. التحديد مرتبط بالصفحة المعروضة حتى لا يتم تنفيذ إجراء على نتائج غير ظاهرة للمستخدم.

الصلاحيات:
إضافة أو استيراد جهات الاتصال مرتبطة بصلاحية تشغيلية، بينما إدارة Custom Fields تتطلب صلاحية إعدادات أعلى.$ar$,
    $en$The Contacts page centralizes customer-record management.

Search and filtering:
• Search supports name, phone number, and email.
• Contacts can be filtered by one or more tags.
• When multiple tags are selected, matching any selected tag can include the contact.
• Results are paginated at 25 contacts per page.

Data management:
• Add Contact creates a new record.
• Edit updates an existing record.
• Contact Detail opens the customer record.
• Import brings in contact data in bulk.
• Custom Fields extend the contact model for business-specific information.

Bulk actions:
Users can select contacts on the currently loaded page and perform a bulk delete. Selection is page-scoped so hidden results are not silently included.

Permissions:
Adding or importing contacts uses an operational permission, while Custom Fields management requires a higher settings-level permission.$en$,
    'published',90,
    'إدارة Contacts والتصنيفات والاستيراد في Zaghloul','Managing Contacts, Tags, and Imports in Zaghloul',
    'دليل البحث والتصفية والاستيراد والحقول المخصصة والإجراءات الجماعية في Contacts.',
    'Guide to contact search, tagging, import, custom fields, and bulk actions.',
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,'tcrm-zaghloul-broadcasts',
    'إنشاء Broadcast في Zaghloul خطوة بخطوة','Creating a Broadcast in Zaghloul Step by Step',
    'أنشئ حملة واتساب عبر Template ثم اختر الجمهور وخصص المتغيرات وأرسلها أو احفظها Draft.',
    'Build a WhatsApp broadcast by choosing a template, audience, personalization, and send or draft action.',
    $ar$إنشاء Broadcast جديد في Zaghloul يتم من خلال Wizard من أربع مراحل.

1. Template
اختر Message Template المناسب للحملة.

2. Audience
يمكن تحديد الجمهور باستخدام:
• All Contacts.
• Tags.
• Custom Field بشرط is أو is_not أو contains.
• CSV contacts.
كما يمكن استخدام Tags للاستبعاد من الجمهور.

3. Personalize
اربط متغيرات الـTemplate بقيم Static أو Contact Field أو Custom Field. وإذا كان الـTemplate يحتاج Header Media يمكن إضافة رابط الوسائط.

4. Send
أدخل اسم الـBroadcast وراجع الإعدادات ثم ابدأ الإرسال. يعرض النظام حالة Processing وProgress أثناء التنفيذ، وبعد الإنشاء ينتقل إلى صفحة تفاصيل الـBroadcast.

Save Draft:
يمكن حفظ الحملة كـDraft قبل الإرسال. النسخة الحالية تحفظ بيانات كافية للتعرف على المسودة، لكنها لا تعيد كل حالة الـWizard بالتفصيل عند الرجوع إليها؛ لذلك راجع الجمهور والمتغيرات قبل الإرسال النهائي.$ar$,
    $en$A new Zaghloul Broadcast is created through a four-step wizard.

1. Template
Choose the Message Template for the campaign.

2. Audience
The audience can be based on:
• All Contacts.
• Tags.
• A Custom Field with is, is_not, or contains.
• CSV contacts.
Tags can also be used for exclusions.

3. Personalize
Map template variables to Static values, Contact Fields, or Custom Fields. A Header Media URL can also be supplied when the template requires media.

4. Send
Name the broadcast, review the configuration, and start sending. The interface exposes processing progress, then opens the broadcast detail page after creation.

Save Draft:
A broadcast can be saved as a draft before sending. The current implementation preserves enough data to identify the draft, but it does not fully round-trip every wizard choice when reopened, so audience and variables should be reviewed before final sending.$en$,
    'published',100,
    'إنشاء Broadcast في Zaghloul خطوة بخطوة','Creating a Broadcast in Zaghloul Step by Step',
    'شرح Template وAudience وPersonalization والإرسال وحفظ Draft في Broadcasts.',
    'Guide to templates, audiences, personalization, sending, and drafts in Zaghloul Broadcasts.',
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,'tcrm-zaghloul-automations',
    'إنشاء وإدارة Automations في Zaghloul','Creating and Managing Automations in Zaghloul',
    'ابدأ من Automation جاهزة أو أنشئ واحدة جديدة، ثم فعّلها وراجع Logs وعدد مرات التشغيل.',
    'Start from an automation template or create a new automation, then activate it and review runs and logs.',
    $ar$Automations في Zaghloul تستخدم لتقليل العمل اليدوي في سيناريوهات متكررة.

Templates الجاهزة المؤكدة:
• Welcome Message.
• Out of Office.
• Lead Qualifier.
• Follow-up Reminder.

من صفحة Automations يمكنك:
1. إنشاء Automation جديدة أو البدء من Template.
2. تفعيل أو إيقاف Automation باستخدام Switch.
3. فتح Automation للتعديل.
4. Duplicate لإنشاء نسخة منها.
5. View Logs لمراجعة سجلات التشغيل.
6. Delete عند عدم الحاجة إليها.

كل Automation تعرض Trigger مختصرًا، وعدد Runs، ووقت Last Run عندما يكون متاحًا.

ملاحظة صلاحيات:
إنشاء Automations مرتبط بصلاحية إرسال الرسائل. إذا كانت الصلاحية غير متاحة، يظل عرض الصفحة ممكنًا لكن إجراء الإنشاء يكون مقيدًا.$ar$,
    $en$Zaghloul Automations reduce manual work in repeatable communication scenarios.

Confirmed starter templates include:
• Welcome Message.
• Out of Office.
• Lead Qualifier.
• Follow-up Reminder.

From the Automations page you can:
1. Create a new automation or start from a template.
2. Activate or pause an automation with its switch.
3. Open it for editing.
4. Duplicate it.
5. View Logs for execution history.
6. Delete it when no longer needed.

Each automation can show its trigger summary, run count, and last-run timing.

Permission note:
Creating automations is tied to the messaging permission. A user can still reach the page while the creation action itself may be gated.$en$,
    'published',110,
    'إنشاء وإدارة Automations في Zaghloul','Creating and Managing Automations in Zaghloul',
    'دليل Templates والتفعيل والتعديل والنسخ وLogs في Zaghloul Automations.',
    'Guide to templates, activation, editing, duplication, and logs in Zaghloul Automations.',
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,'tcrm-zaghloul-flows',
    'استخدام Flows في Zaghloul لبناء رحلات محادثة','Using Zaghloul Flows to Build Conversation Journeys',
    'أنشئ Flow من الصفر أو من Template وحدد Trigger وتابع حالة التشغيل وعدد مرات التنفيذ.',
    'Create a flow from scratch or a template, define its trigger, and track status and execution count.',
    $ar$Flows في Zaghloul هي مساحة لبناء رحلات محادثة أكثر تنظيمًا، والواجهة الحالية تضع عليها علامة Beta.

إنشاء Flow:
• Start from Template عندما توجد Templates متاحة.
• Start Blank لإنشاء Flow جديد من الصفر.

Triggers المؤكدة في القائمة:
• Keyword: تشغيل Flow عند كلمات محددة.
• First Inbound Message: تشغيله مع أول رسالة واردة.
• Manual: تشغيل يدوي.

حالات Flow:
• Draft.
• Active.
• Archived.

كل كارت Flow يعرض الاسم والوصف أو ملخص الـTrigger وعدد مرات التشغيل. يمكن فتح Flow للتعديل أو حذفه.

بما أن Flows ما زالت Beta، استخدمها في سيناريو قابل للاختبار أولًا، وراجع Trigger والنتيجة قبل الاعتماد عليها في مسار عميل حساس.$ar$,
    $en$Zaghloul Flows provide a structured way to build conversation journeys, and the current interface marks the feature as Beta.

Creating a Flow:
• Start from Template when templates are available.
• Start Blank to create a new flow from scratch.

Confirmed trigger types shown by the current implementation:
• Keyword: starts when configured keywords match.
• First Inbound Message: starts on the first inbound message.
• Manual: starts manually.

Flow states:
• Draft.
• Active.
• Archived.

Each flow card shows the name, description or trigger summary, and execution count. A flow can be opened for editing or deleted.

Because Flows is still marked Beta, test the journey and its trigger before relying on it for a sensitive customer process.$en$,
    'published',120,
    'استخدام Flows في Zaghloul لبناء رحلات محادثة','Using Zaghloul Flows to Build Conversation Journeys',
    'شرح إنشاء Flows وTriggers والحالات والـTemplates في Zaghloul.',
    'Guide to Zaghloul Flows, triggers, states, and templates.',
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,'tcrm-zaghloul-pipelines-deals',
    'إدارة Pipelines وDeals في Zaghloul','Managing Pipelines and Deals in Zaghloul',
    'نظّم الصفقات على Pipeline مرئي، حرّك Deal بين المراحل، وراجع Analytics مع احترام صلاحيات الإنشاء والإعداد.',
    'Organize deals on a visual pipeline, move deals between stages, and review analytics with role-aware controls.',
    $ar$Pipelines في Zaghloul تربط محادثات واتساب بمتابعة الفرص والصفقات داخل نفس بيئة العمل.

عند عدم وجود Pipeline، يمكن للنظام إنشاء Sales Pipeline افتراضي بالمراحل:
1. New Lead.
2. Qualified.
3. Proposal Sent.
4. Negotiation.
5. Won.

الوظائف الرئيسية:
• اختيار Pipeline من القائمة عند وجود أكثر من واحد.
• Add Deal لإضافة صفقة جديدة.
• إضافة Deal مباشرة إلى Stage محددة.
• تحريك Deal بين المراحل على الـBoard مع حفظ المرحلة الجديدة.
• فتح Deal للتعديل.
• Pipeline Analytics لقراءة توزيع وقيمة الصفقات.
• Pipeline Settings لإدارة المراحل والإعدادات.

الصلاحيات منفصلة:
إنشاء Pipeline أو تعديل إعداداته يحتاج صلاحية إعدادات أعلى، بينما إنشاء Deal إجراء تشغيلي متاح لصلاحية إرسال الرسائل. هذا الفصل يمنع المستخدم التشغيلي من تغيير هيكل الـPipeline لمجرد أنه يستطيع إضافة صفقة.$ar$,
    $en$Zaghloul Pipelines connect WhatsApp communication with opportunity and deal tracking in the same workspace.

When no pipeline exists, the application can seed a default Sales Pipeline with these stages:
1. New Lead.
2. Qualified.
3. Proposal Sent.
4. Negotiation.
5. Won.

Core workflows:
• Select among multiple pipelines.
• Add a Deal.
• Add a Deal directly into a chosen stage.
• Move a Deal between stages on the board and persist the new stage.
• Open a Deal for editing.
• Use Pipeline Analytics to review deal distribution and value.
• Use Pipeline Settings to manage structure and stages.

Permissions are intentionally separated:
Creating or configuring a pipeline requires a higher settings permission, while creating deals is an operational messaging-level action. This prevents an operational user from changing the pipeline structure simply because they can create a deal.$en$,
    'published',130,
    'إدارة Pipelines وDeals في Zaghloul','Managing Pipelines and Deals in Zaghloul',
    'دليل Pipeline Board والمراحل والصفقات والتحليلات والصلاحيات في Zaghloul.',
    'Guide to pipeline boards, stages, deals, analytics, and permissions in Zaghloul.',
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,'tcrm-zaghloul-ai-agents',
    'إعداد واختبار AI Agents في Zaghloul','Setting Up and Testing AI Agents in Zaghloul',
    'اضبط AI Agent بمفتاحك الخاص، اختبره في Playground، وتابع Usage قبل استخدامه في ردود العملاء.',
    'Configure a bring-your-own-key AI agent, test it in the Playground, and review Usage before customer replies.',
    $ar$صفحة AI Agents في Zaghloul مصممة لتجهيز المساعد الذكي واختباره قبل استخدامه مع العملاء.

التبويبات الأساسية:
• Playground: لاختبار سلوك الـAgent.
• Setup: لإعداد تكوين الـAI.
• Usage: لمراجعة الاستخدام، ويظهر للمستخدمين الذين لديهم صلاحية إعدادات مناسبة.

سلوك البداية:
إذا كان إعداد AI مكتملًا، يفتح Zaghloul على Playground. إذا لم يكن الإعداد مكتملًا، يوجه المستخدم إلى Setup أولًا.

النموذج الحالي Bring Your Own Key:
المستخدم أو المسؤول يضيف إعداد الـAI الخاص بالحساب بدل الاعتماد على Agent مجهز مسبقًا بدون تحكم.

أفضل ممارسة قبل التفعيل مع العملاء:
1. أكمل Setup.
2. اختبر أمثلة واقعية في Playground.
3. راجع أسلوب الإجابة والحدود قبل السماح باستخدامها في Inbox.
4. راجع Usage دوريًا إذا كانت صلاحيتك تسمح بذلك.$ar$,
    $en$The Zaghloul AI Agents page is designed to configure and test an assistant before using it with customers.

Core tabs:
• Playground: tests agent behavior.
• Setup: configures the AI connection.
• Usage: reviews usage and is shown to users with the appropriate settings permission.

Initial behavior:
When AI is already configured, Zaghloul opens the Playground. When configuration is missing, the user is directed to Setup first.

The current model is Bring Your Own Key:
The user or administrator supplies the account AI configuration instead of relying on an uncontrolled preconfigured agent.

Recommended process before customer use:
1. Complete Setup.
2. Test realistic scenarios in the Playground.
3. Review tone and boundaries before using AI in the Inbox.
4. Review Usage periodically when your role allows it.$en$,
    'published',140,
    'إعداد واختبار AI Agents في Zaghloul','Setting Up and Testing AI Agents in Zaghloul',
    'شرح Setup وPlayground وUsage ونموذج Bring Your Own Key في Zaghloul AI Agents.',
    'Guide to Setup, Playground, Usage, and the Bring Your Own Key model in Zaghloul AI Agents.',
    NOW(),'general',false,NULL,'[]'::jsonb
  ),
  (
    owner_tenant,v_module_id,v_category_id,v_subcategory_id,'tcrm-zaghloul-whatsapp-cloud-setup',
    'تهيئة WhatsApp Cloud وربط الرقم في Zaghloul','Configuring WhatsApp Cloud and Registering a Number in Zaghloul',
    'اربط Zaghloul بـWhatsApp Cloud باستخدام بيانات Meta، اختبر الاتصال، وتحقق من تسجيل الرقم والـWebhook.',
    'Connect Zaghloul to WhatsApp Cloud with Meta credentials, test the connection, and verify number registration and webhooks.',
    $ar$إعداد WhatsApp داخل تطبيق Zaghloul الحالي يعتمد على WhatsApp Cloud API وبيانات Meta الخاصة بالحساب.

البيانات التي قد تحتاجها:
• Phone Number ID.
• WABA ID عند توفره.
• Access Token.
• Verify Token للـWebhook عند الحاجة.
• PIN عند التسجيل أو تغيير الرقم حسب حالة الحساب.

الأمان:
حفظ الإعداد يتم عبر API في السيرفر حتى يتم التحقق من بيانات Meta وتشفير Access Token. لا تعتمد على كتابة Token مباشرة في قاعدة البيانات.

بعد الحفظ:
• Test Connection للتحقق من الوصول إلى Meta.
• Registration Status للتأكد من أن الرقم مسجل لاستقبال الأحداث.
• Verify Registration لفحص الخطوات المطلوبة ووضع الرقم الفعلي.
• Webhook URL يمكن نسخه لاستخدامه في إعداد Meta.

الحساب المشترك:
WhatsApp configuration مرتبطة بالحساب Account وليس بالمستخدم الذي أدخلها فقط، لذلك أعضاء الحساب يستخدمون نفس الاتصال وفق صلاحياتهم.

Inbound Media:
يوجد إعداد للتحكم في Mirror Inbound Media، وتغييره مقيد بصلاحية إعدادات مناسبة.

إذا فشل الاتصال أو ظهر أن Token غير صالح، استخدم رسائل الحالة ومسار Reset/Reconfigure بدل اعتبار Inbox مشكلة مستقلة.$ar$,
    $en$The current Zaghloul WhatsApp setup uses the WhatsApp Cloud API and the account's Meta credentials.

Information you may need:
• Phone Number ID.
• WABA ID when applicable.
• Access Token.
• Verify Token for webhook setup when needed.
• PIN when registration or a number change requires it.

Security:
Configuration is saved through the server API so Meta credentials can be verified and the Access Token can be encrypted. Do not treat a direct database token write as a valid setup path.

After saving:
• Test Connection verifies access to Meta.
• Registration Status indicates whether the number is registered for event delivery.
• Verify Registration checks the required wiring and live state.
• The Webhook URL can be copied for Meta configuration.

Shared account behavior:
WhatsApp configuration is account-scoped rather than tied only to the user who saved it, so account members share the connection according to their permissions.

Inbound Media:
A setting controls Mirror Inbound Media, and changing it is protected by the appropriate settings permission.

If the connection fails or the token is invalid, use the status messages and Reset/Reconfigure path instead of treating the Inbox itself as the root problem.$en$,
    'published',150,
    'تهيئة WhatsApp Cloud وربط الرقم في Zaghloul','Configuring WhatsApp Cloud and Registering a Number in Zaghloul',
    'دليل Phone Number ID وWABA ID وAccess Token والتسجيل والWebhook في Zaghloul.',
    'Guide to Phone Number ID, WABA ID, Access Token, number registration, and webhooks in Zaghloul.',
    NOW(),'general',false,NULL,'[]'::jsonb
  )
  ON CONFLICT (tenant_id, slug) DO UPDATE
  SET module_id = EXCLUDED.module_id,
      category_id = EXCLUDED.category_id,
      subcategory_id = EXCLUDED.subcategory_id,
      title_ar = EXCLUDED.title_ar,
      title_en = EXCLUDED.title_en,
      excerpt_ar = EXCLUDED.excerpt_ar,
      excerpt_en = EXCLUDED.excerpt_en,
      body_ar = EXCLUDED.body_ar,
      body_en = EXCLUDED.body_en,
      status = EXCLUDED.status,
      sort_order = EXCLUDED.sort_order,
      seo_title_ar = EXCLUDED.seo_title_ar,
      seo_title_en = EXCLUDED.seo_title_en,
      seo_description_ar = EXCLUDED.seo_description_ar,
      seo_description_en = EXCLUDED.seo_description_en,
      published_at = COALESCE(kb_articles.published_at, NOW()),
      visibility_scope = 'general',
      consumer_hidden = false,
      canonical_article_id = NULL,
      media = EXCLUDED.media,
      updated_at = NOW();

  SELECT count(*)::INTEGER
  INTO published_count
  FROM kb_articles
  WHERE tenant_id = owner_tenant
    AND slug IN (
      'tcrm-ai-staff-zaghloul',
      'tcrm-zaghloul-inbox-realtime',
      'tcrm-zaghloul-contacts',
      'tcrm-zaghloul-broadcasts',
      'tcrm-zaghloul-automations',
      'tcrm-zaghloul-flows',
      'tcrm-zaghloul-pipelines-deals',
      'tcrm-zaghloul-ai-agents',
      'tcrm-zaghloul-whatsapp-cloud-setup'
    )
    AND status = 'published'
    AND visibility_scope = 'general'
    AND consumer_hidden = false
    AND length(trim(title_ar)) > 0
    AND length(trim(title_en)) > 0
    AND length(trim(body_ar)) > 0
    AND length(trim(body_en)) > 0;

  IF published_count <> 9 THEN
    RAISE EXCEPTION 'TCRMHC_PHASE14_CONTENT_VERIFY_FAILED expected=9 actual=%', published_count;
  END IF;
END $$;

COMMIT;
