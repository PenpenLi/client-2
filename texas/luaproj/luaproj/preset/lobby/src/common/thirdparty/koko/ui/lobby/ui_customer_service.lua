
local data = require("koko.data")
local CC = require "comm.CC"

local ctrl = class("kkCustomerService", kk.view)

local _svProblemWidth = 791
local _svProblemHeight = 88

local _svProblemWidth2 = 796
local _svProblemHeight2 = 265

local _count = 4

local txtPhone = {
    [false] = {
        {"客服QQ：3091677691", "koko/atlas/all_common/button/2001.png", contact_customer, "3091677691", true, nil},
        {"客服电话：0571-87218727", "koko/atlas/all_common/button/2002.png", call_phone, "057187218727", true, nil},
        {"官方QQ群：519815058", "koko/atlas/all_common/button/2003.png", join_qqgroup, nil, true, nil},
        {"微信公众号：KOKOGame", "koko/atlas/all_common/button/2004.png", nil, nil, false, "微信公众号"},
        {"官方网站：www.koko.com", "koko/atlas/all_common/button/2005.png", callweb, "http://www.koko.com", true, "官方网站"},
    },
    [true] = {
        {"客服QQ：3091677691", "koko/atlas/all_common/button/2001.png", contact_customer, "3091677691", false, nil},
        {"客服电话：0571-87218727", "koko/atlas/all_common/button/2002.png", call_phone, "057187218727", false, nil},
        {"官方QQ群：519815058", "koko/atlas/all_common/button/2003.png", join_qqgroup, nil, false, nil},
        {"官方网站：www.koko.com", "koko/atlas/all_common/button/2005.png", callweb, "http://www.koko.com", true, "官方网站"},
    }
}

local problemTxt = 
{
    {"完善个人信息有什么用？", 
    [[完善您的个人信息，包括（身份证、姓名、手机号、email、地址等）使您的个人信息增至60%以上（最高至100%）除了可以提高您的“账号级别”，使您享受到更多优质的服务，最重要是可以让您的账号安全有了保障，所以请尽可能的补全并完善它吧。
]]
    },
    {"什么是保险箱？", 
    [[保险箱是提供的保护您账户金币安全的一种服务，你可以把大额金币存入保险箱，当需要取出金币时需要验证二级密码。 
]]
    },
    {"禁止私下交易", 
    [[1、禁止任何利用人民币私自在游戏中买卖虚拟物品（游戏币及游戏道具）的交易行为，一经发现和查实，将对参与交易的双方的游戏帐号进行封停，虚拟物品进行扣除。
2、禁止在游戏中进行上述违规交易的广告宣传行为（包括通过各种信息的发送），一经发现和查实，将对违规游戏帐号进行封停处理。
3、参与上述违规交易的玩家，如因此造成任何损失，《KOKO游戏》运营团队概不负责。
4、私下交易得不到任何官方的保护，而且其中多是欺骗和陷阱。我们再次提醒广大玩家务必提高自我保护和账号安全意识，不要使用过于简单的密码；及时申请相关密保服务；定期使用杀毒软件对电脑/手机进行扫描清除病毒；在公共场所上网要注意周围环境及账号安全；不要在游戏中轻信他人言语，泄露账号信息。
5、最终解释权归《KOKO游戏》运营团队所有。
]]
    },
    {"密码安全常识", 
    [[不要使用可轻易获得的关于您的信息作为密码。这包括执照号码、电话号码、身份证号码、工作证号码、生日、您的手机号码、您所居住的街道的名字，等等。
•定期更换您的密码，因为8位数以上的字母、数字和其他符号的组合也不是绝对无懈可击的，但更换密码前请确保所使用电脑的安全。
•不要把密码轻易告诉任何人。尽可能避免因为对方是您的网友或现实生活中的朋友而把密码告诉他。
•避免多个资源共用一个密码，一旦你的一个密码泄露，你所有的资源都受到威胁。
•不要让Windows或者IE保存你任何形式的密码,因为*符号掩盖不了真实的密码,而且在这种情况下,Windows都会将密码以弱智的加密算法储存在某个文件里的。
•不要随意放置您的帐号密码，注意把帐号密码存放在相对安全的位置。密码写在台历上、或者记在钱包上、或者写入PDA都是危险的做法。
•申请密码保护，也就是去设置安全码，安全码不要和密码设置的一样。如果您没有设置安全码，那么别人一旦破解您的密码，就可以把您的密码和注册资料 ( 除证件号码 ) 全部修改。
•不使用简单危险密码，推荐使用的密码设置为8位以上的大小写字母、数字和其他符号的组合。
 
以下为简单危险密码：
•密码和用户名相同，如用户名和密码均为test
•使用8位以下的数字作为密码。数字只有10个，8位数字组成方式只有10的8次方=100，000，000种，按普通计算机每秒搜索3～4万种的速度计算，黑客软件只需要不到3小时就可以破解您的密码了。
•使用5位以下的小写字母加数字作为口令。小写字母加数字一共36位，组合方式只有36的5次方=60466176种可能性，按普通的计算机每秒搜索3～4万种的速度计算，黑客软件只需要25分钟就可以破解您的密码。 
•密码为连续或相同的数字，如123、1234、111、1111、0000、123456等。
•使用自己或亲友的生日作为密码。
•使用自己的姓名作为密码。
•使用常用的英文单词作为密码，如software ,hello ,hongkong 等等,最好不用单词做密码,如果要用，可以在后面加复数s,或者符号,这样可以减小被字典档猜出的机会；能在字典中见到的密码，用互联网上到处都是的"密码破译程序"很轻松就可以攻破。
]]
    },
}

local protocolTxt = 
[[  海象网络服务协议
　　【首部及导言】
  欢迎您使用海象网络的服务！
  为使用海象网络的服务，您应当阅读并遵守《海象网络服务协议》（以下简称“本协议”）。请您务必审慎阅读、充分理解各条款内容，特别是免除或者限制责任的条款、管辖与法律适用条款，以及开通或使用某项服务的单独协议。限制、免责条款可能以黑体加粗或加下划线的形式提示您重点注意。除非您已阅读并接受本协议所有条款，否则您无权使用海象网络提供的服务。您使用海象网络的服务即视为您已阅读并同意上述协议的约束。
  如果您未满18周岁，请在法定监护人的陪同下阅读本协议，并特别注意未成年人使用条款。
  一、【协议的范围】
  1.1本协议是您与海象网络之间关于用户使用海象网络相关服务所订立的协议。“海象网络”是指海象网络公司及其相关服务可能存在的运营关联单位。“用户”是指使用海象网络相关服务的使用人，在本协议中更多地称为“您”。
  1.2本协议项下的服务是指海象网络向用户提供的包括但不限于即时通讯、网络媒体、互联网增值、互动娱乐、电子商务和广告等产品及服务（以下简称“本服务”）。
  1.3本协议内容同时包括《隐私政策》,且您在使用海象网络某一特定服务时，该服务可能会另有单独的协议、相关业务规则等（以下统称为“单独协议”）。上述内容一经正式发布，即为本协议不可分割的组成部分，您同样应当遵守。您对前述任何业务规则、单独协议的接受，即视为您对本协议全部的接受。
  二、【帐号与密码安全】
  2.1您在使用海象网络的服务时可能需要注册一个koko帐号。关于您使用帐号的具体规则，请遵守单独协议。
  2.2海象网络特别提醒您应妥善保管您的帐号和密码。当您使用完毕后，应安全退出。因您保管不善可能导致遭受盗号或密码失窃，责任由您自行承担。
  三、【用户个人信息保护】
  3.1保护用户个人信息是海象网络的一项基本原则。海象网络将按照本协议及《隐私政策》的规定收集、使用、储存和分享您的个人信息。本协议对个人信息保护规定的内容与上述《隐私政策》有相冲突的，及本协议对个人信息保护相关内容未作明确规定的，均应以《隐私政策》的内容为准。
  3.2您在注册帐号或使用本服务的过程中，可能需要填写一些必要的信息。若国家法律法规有特殊规定的，您需要填写真实的身份信息。若您填写的信息不完整，则无法使用本服务或在使用过程中受到限制。
  3.3一般情况下，您可随时浏览、修改自己提交的信息，但出于安全性和身份识别（如号码申诉服务）的考虑，您可能无法修改注册时提供的初始注册信息及其他验证信息。
  3.4海象网络将运用各种安全技术和程序建立完善的管理制度来保护您的个人信息，以免遭受未经授权的访问、使用或披露。
  3.5海象网络不会将您的个人信息转移或披露给任何非关联的第三方，除非：
  （1）相关法律法规或法院、政府机关要求；
  （2）为完成合并、分立、收购或资产转让而转移；
  （3）为提供您要求的服务所必需。
  3.6海象网络非常重视对未成年人个人信息的保护。若您是18周岁以下的未成年人，在使用海象网络的服务前，应事先取得您家长或法定监护人（以下简称"监护人"）的书面同意。
  四、【使用本服务的方式】
  4.1除非您与海象网络另有约定，您同意本服务仅为您个人非商业性质的使用。
  4.2您应当通过海象网络提供或认可的方式使用本服务。您依本协议条款所取得的权利不可转让。
  4.3您不得使用未经海象网络授权的插件、外挂或第三方工具对本协议项下的服务进行干扰、破坏、修改或施加其他影响。
  五、【按现状提供服务】
您理解并同意，海象网络的服务是按照现有技术和条件所能达到的现状提供的。海象网络会尽最大努力向您提供服务，确保服务的连贯性和安全性；但海象网络不能随时预见和防范法律、技术以及其他风险，包括但不限于不可抗力、病毒、木马、黑客攻击、系统不稳定、第三方服务瑕疵、政府行为等原因可能导致的服务中断、数据丢失以及其他的损失和风险。
  六、【自备设备】
  6.1您应当理解，您使用海象网络的服务需自行准备与相关服务有关的终端设备（如电脑、调制解调器等装置），并承担所需的费用（如电话费、上网费等费用）。
  6.2您理解并同意，您使用本服务时会耗用您的终端设备和带宽等资源。
  七、【广告】
  7.1您同意海象网络可以在提供服务的过程中自行或由第三方广告商向您发送广告、推广或宣传信息（包括商业与非商业信息），其方式和范围可不经向您特别通知而变更。
  7.2海象网络可能为您提供选择关闭广告信息的功能，但任何时候您都不得以本协议未明确约定或海象网络未书面许可的方式屏蔽、过滤广告信息。
  7.3海象网络依照法律的规定对广告商履行相关义务，您应当自行判断广告信息的真实性并为自己的判断行为负责，除法律明确规定外，您因依该广告信息进行的交易或前述广告商提供的内容而遭受的损失或损害，海象网络不承担责任。
  7.4您同意，对海象网络服务中出现的广告信息，您应审慎判断其真实性和可靠性，除法律明确规定外，您应对依该广告信息进行的交易负责。
  八、【收费服务】
  8.1海象网络的部分服务是以收费方式提供的，如您使用收费服务，请遵守相关的协议。
  8.2海象网络可能根据实际需要对收费服务的收费标准、方式进行修改和变更，海象网络也可能会对部分免费服务开始收费。前述修改、变更或开始收费前，海象网络将在相应服务页面进行通知或公告。如果您不同意上述修改、变更或付费内容，则应停止使用该服务。
  九、【第三方提供的产品或服务】
您在海象网络平台上使用第三方提供的产品或服务时，除遵守本协议约定外，还应遵守第三方的用户协议。海象网络和第三方对可能出现的纠纷在法律规定和约定的范围内各自承担责任。
  十、【基于软件提供服务】
若海象网络依托“软件”向您提供服务，您还应遵守以下约定：
10.1您在使用本服务的过程中可能需要下载软件，对于这些软件，海象网络给予您一项个人的、不可转让及非排他性的许可。您仅可为访问或使用本服务的目的而使用这些软件。
10.2为了改善用户体验、保证服务的安全性及产品功能的一致性，海象网络可能会对软件进行更新。您应该将相关软件更新到最新版本，否则海象网络并不保证其能正常使用。
10.3海象网络可能为不同的终端设备开发不同的软件版本，您应当根据实际情况选择下载合适的版本进行安装。您可以直接从海象网络的网站上获取软件，也可以从得到海象网络授权的第三方获取。如果您从未经海象网络授权的第三方获取软件或与软件名称相同的安装程序，海象网络无法保证该软件能够正常使用，并对因此给您造成的损失不予负责。
10.4除非海象网络书面许可，您不得从事下列任一行为： 
（1）删除软件及其副本上关于著作权的信息； 
（2）对软件进行反向工程、反向汇编、反向编译，或者以其他方式尝试发现软件的源代码； 
（3）对海象网络拥有知识产权的内容进行使用、出租、出借、复制、修改、链接、转载、汇编、发表、出版、建立镜像站点等； 
（4）对软件或者软件运行过程中释放到任何终端内存中的数据、软件运行过程中客户端与服务器端的交互数据，以及软件运行所必需的系统数据，进行复制、修改、增加、删除、挂接运行或创作任何衍生作品，形式包括但不限于使用插件、外挂或非经海象网络授权的第三方工具/服务接入软件和相关系统； 
（5）通过修改或伪造软件运行中的指令、数据，增加、删减、变动软件的功能或运行效果，或者将用于上述用途的软件、方法进行运营或向公众传播，无论这些行为是否为商业目的； 
（6）通过非海象网络开发、授权的第三方软件、插件、外挂、系统，登录或使用海象网络软件及服务，或制作、发布、传播非海象网络开发、授权的第三方软件、插件、外挂、系统。
  十一、【知识产权声明】
  11.1海象网络在本服务中提供的内容（包括但不限于网页、文字、图片、音频、视频、图表等）的知识产权归海象网络所有，用户在使用本服务中所产生的内容的知识产权归用户或相关权利人所有。
  11.2除另有特别声明外，海象网络提供本服务时所依托软件的著作权、专利权及其他知识产权均归海象网络所有。
  11.3海象网络在本服务中所使用的“海象网络”及海象形象等商业标识，其著作权或商标权归海象网络所有。
  11.4上述及其他任何本服务包含的内容的知识产权均受到法律保护，未经海象网络、用户或相关权利人书面许可，任何人不得以任何形式进行使用或创造相关衍生作品。
  十二、【用户违法行为】
  12.1您在使用本服务时须遵守法律法规，不得利用本服务从事违法违规行为，包括但不限于：
  （1）发布、传送、传播、储存危害国家安全统一、破坏社会稳定、违反公序良俗、侮辱、诽谤、淫秽、暴力以及任何违反国家法律法规的内容；
  （2）发布、传送、传播、储存侵害他人知识产权、商业秘密等合法权利的内容；
  （3）恶意虚构事实、隐瞒真相以误导、欺骗他人；
  （4）发布、传送、传播广告信息及垃圾信息；
  （5）其他法律法规禁止的行为。
  12.2如果您违反了本条约定，相关国家机关或机构可能会对您提起诉讼、罚款或采取其他制裁措施，并要求海象网络给予协助。造成损害的，您应依法予以赔偿，海象网络不承担任何责任。
  12.3如果海象网络发现或收到他人举报您发布的信息违反本条约定，海象网络有权进行独立判断并采取技术手段予以删除、屏蔽或断开链接。同时，海象网络有权视用户的行为性质，采取包括但不限于暂停或终止服务，限制、冻结或终止koko账号的使用，追究法律责任等措施。
  12.4您违反本条约定，导致任何第三方损害的，您应当独立承担责任；海象网络因此遭受损失的，您也应当一并赔偿。
  十三、【遵守当地法律监管】
  13.1您在使用本服务过程中应当遵守当地相关的法律法规，并尊重当地的道德和风俗习惯。如果您的行为违反了当地法律法规或道德风俗，您应当为此独立承担责任。
  13.2您应避免因使用本服务而使海象网络卷入政治和公共事件，否则海象网络有权暂停或终止对您的服务。
  十四、【用户发送、传播的内容与第三方投诉处理】
  14.1您通过本服务发送或传播的内容（包括但不限于网页、文字、图片、音频、视频、图表等）均由您自行承担责任。
  14.2您发送或传播的内容应有合法来源，相关内容为您所有或您已获得权利人的授权。
  14.3您同意海象网络可为履行本协议或提供本服务的目的而使用您发送或传播的内容。
  14.4如果海象网络收到权利人通知，主张您发送或传播的内容侵犯其相关权利的，您同意海象网络有权进行独立判断并采取删除、屏蔽或断开链接等措施。 
  14.5您使用本服务时不得违反国家法律法规、侵害他人合法权益。您理解并同意，如您被他人投诉侵权或您投诉他人侵权，海象网络有权将争议中相关方的主体、联系方式、投诉相关内容等必要信息提供给其他争议方或相关部门，以便及时解决投诉纠纷，保护他人合法权益。 
  十五、【不可抗力及其他免责事由】
  15.1您理解并同意，在使用本服务的过程中，可能会遇到不可抗力等风险因素，使本服务发生中断。不可抗力是指不能预见、不能克服并不能避免且对一方或双方造成重大影响的客观事件，包括但不限于自然灾害如洪水、地震、瘟疫流行和风暴等以及社会事件如战争、动乱、政府行为等。出现上述情况时，海象网络将努力在第一时间与相关单位配合，及时进行修复，但是由此给您造成的损失海象网络在法律允许的范围内免责。
  15.2在法律允许的范围内，海象网络对以下情形导致的服务中断或受阻不承担责任：
  （1）受到计算机病毒、木马或其他恶意程序、黑客攻击的破坏；
  （2）用户或海象网络的电脑软件、系统、硬件和通信线路出现故障；
  （3）用户操作不当；
  （4）用户通过非海象网络授权的方式使用本服务；
  （5）其他海象网络无法控制或合理预见的情形。
  15.3您理解并同意，在使用本服务的过程中，可能会遇到网络信息或其他用户行为带来的风险，海象网络不对任何信息的真实性、适用性、合法性承担责任，也不对因侵权行为给您造成的损害负责。这些风险包括但不限于：
  （1）来自他人匿名或冒名的含有威胁、诽谤、令人反感或非法内容的信息；
  （2）因使用本协议项下的服务，遭受他人误导、欺骗或其他导致或可能导致的任何心理、生理上的伤害以及经济上的损失；
  （3）其他因网络信息或用户行为引起的风险。
  15.4您理解并同意，本服务并非为某些特定目的而设计，包括但不限于核设施、军事用途、医疗设施、交通通讯等重要领域。如果因为软件或服务的原因导致上述操作失败而带来的人员伤亡、财产损失和环境破坏等，海象网络不承担法律责任。
  15.5海象网络依据本协议约定获得处理违法违规内容的权利，该权利不构成海象网络的义务或承诺，海象网络不能保证及时发现违法行为或进行相应处理。
  15.6在任何情况下，您不应轻信借款、索要密码或其他涉及财产的网络信息。涉及财产操作的，请一定先核实对方身份，并请经常留意海象网络有关防范诈骗犯罪的提示。
  十六、【协议的生效与变更】
  16.1您使用海象网络的服务即视为您已阅读本协议并接受本协议的约束。
  16.2海象网络有权在必要时修改本协议条款。您可以在相关服务页面查阅最新版本的协议条款。
  16.3本协议条款变更后，如果您继续使用海象网络提供的软件或服务，即视为您已接受修改后的协议。如果您不接受修改后的协议，应当停止使用海象网络提供的软件或服务。
十七、【服务的变更、中断、终止】
  17.1海象网络可能会对服务内容进行变更，也可能会中断、中止或终止服务。
  17.2您理解并同意，海象网络有权自主决定经营策略。在海象网络发生合并、分立、收购、资产转让时，海象网络可向第三方转让本服务下相关资产；海象网络也可在单方通知您后，将本协议下部分或全部服务转交由第三方运营或履行。具体受让主体以海象网络通知的为准。
  17.3如发生下列任何一种情形，海象网络有权不经通知而中断或终止向您提供的服务：
  （1）根据法律规定您应提交真实信息，而您提供的个人资料不真实、或与注册时信息不一致又未能提供合理证明；
  （2）您违反相关法律法规或本协议的约定；
  （3）按照法律规定或主管部门的要求；
  （4）出于安全的原因或其他必要的情形。
  17.4海象网络有权按本协议8.2条的约定进行收费。若您未按时足额付费，海象网络有权中断、中止或终止提供服务。
  17.5您有责任自行备份存储在本服务中的数据。如果您的服务被终止，海象网络可以从服务器上永久地删除您的数据,但法律法规另有规定的除外。服务终止后，海象网络没有义务向您返还数据。
  十八、【管辖与法律适用】
  18.1本协议的成立、生效、履行、解释及纠纷解决，适用中华人民共和国大陆地区法律（不包括冲突法）。
  18.2本协议签订地为中华人民共和国浙江省杭州市经济技术开发区。
  18.3若您和海象网络之间发生任何纠纷或争议，首先应友好协商解决；协商不成的，您同意将纠纷或争议提交本协议签订地（即中国浙江省杭州市经济技术开发区）有管辖权的人民法院管辖。
  18.4本协议所有条款的标题仅为阅读方便，本身并无实际涵义，不能作为本协议涵义解释的依据。
  18.5本协议条款无论因何种原因部分无效或不可执行，其余条款仍有效，对双方具有约束力。
  十九、【未成年人使用条款】
  19.1若用户未满18周岁，则为未成年人，应在监护人监护、指导下阅读本协议和使用本服务。
  19.2未成年人用户涉世未深，容易被网络虚象迷惑，且好奇心强，遇事缺乏随机应变的处理能力，很容易被别有用心的人利用而又缺乏自我保护能力。因此，未成年人用户在使用本服务时应注意以下事项，提高安全意识，加强自我保护：
  （1）认清网络世界与现实世界的区别，避免沉迷于网络，影响日常的学习生活；
  （2）填写个人资料时，加强个人保护意识，以免不良分子对个人生活造成骚扰；
  （3）在监护人或老师的指导下，学习正确使用网络；
  （4）避免陌生网友随意会面或参与联谊活动，以免不法分子有机可乘，危及自身安全。
  19.3监护人、学校均应对未成年人使用本服务时多做引导。特别是家长应关心子女的成长，注意与子女的沟通，指导子女上网应该注意的安全问题，防患于未然。
  二十、【其他】
如果您对本协议或本服务有意见或建议，可与海象网络客户服务部门联系，我们会给予您必要的帮助。（正文完）
              　　　　　海象网络公司
]]
--关于我们
local WithMeTxt = 
[[
    海象竞技斗地主是海象网络科技（杭州）股份有限公司自主研发并运营的棋牌游戏，海象网络始终专注于发掘特色棋牌游戏、基于地方互联网社交生态圈，着力打造有“味道”的棋牌游戏。
    海象网络自主研发并运营的棋牌游戏，既原汁原味地保留了棋牌游戏的独特魅力，又巧妙融合了网络游戏的娱乐性、趣味性和便利性，在游戏的丰富、稳定、地道上积累了深厚的用户口碑，为用户打造全新的“游戏+社交”型娱乐体验。
]]

function ctrl:ctor()
    self:setCsbPath("koko/ui/lobby/customer_service.csb")
    self:setAnimation(kk.animScale:create())
end

function ctrl:onInit(node)
    self.phoneScroll = node:findChild("panel/panel3/scrollView")
    self.phoneScroll:setScrollBarEnabled(false)

    self.probleScroll = node:findChild("panel/panel2/scrollView")
    self.probleScroll:setScrollBarOpacity(0)

    node:findChild("panel/left_bar1"):onClick(handler(self, self.left_bar1))
    node:findChild("panel/left_bar2"):onClick(handler(self, self.left_bar2))
    node:findChild("panel/left_bar3"):onClick(handler(self, self.left_bar3))
    node:findChild("panel/panel1/btn1"):onClick(handler(self, self.contactCustomer))
    node:findChild("panel/panel1/btn2"):onClick(function() self:showPage(4) end)
    node:findChild("panel/panel1/btn3"):onClick(function() self:showPage(5) end)
    node:findChild("panel/panel1/btn4"):onClick(handler(self, self.sendErrText), nil, nil, nil, nil, 60)
    node:findChild("panel/panel2/btn1"):onClick(handler(self, self.sendErrText), nil, nil, nil, nil, 60)
    node:findChild("panel/panel3/btn2"):onClick(handler(self, self.sendErrText), nil, nil, nil, nil, 60)
    node:findChild("panel/panel4/btn2"):onClick(handler(self, self.sendErrText), nil, nil, nil, nil, 60)
    node:findChild("panel/panel5/btn2"):onClick(handler(self, self.sendErrText), nil, nil, nil, nil, 60)
    node:findChild("panel/panel5/btn3"):onClick(handler(self, self.onSubmit))
    node:findChild("panel/close"):onClick(mkfunc(kk.uimgr.unload, self))
    self:switchBar(1)
    self:showPage(1)

    self:refresh6() 
    self:refresh3(self.phoneScroll)
    self:refresh4()
    self:adviceEdit()
end

function ctrl:showPage(index)
    for i = 1, 6 do
        if i == index then
            self:getNode():findChild("panel/panel"..i):setVisible(true)
        else
            self:getNode():findChild("panel/panel"..i):setVisible(false)    
        end
    end
    
end

function ctrl:switchBar(index)
    for i = 1, 3 do
        local node = self:getNode():findChild("panel/left_bar"..i)
        local txt = node:findChild("text")
        txt:getVirtualRenderer():setLineSpacing(2)
        node:ignoreContentAdaptWithSize(true)
        if i == index then
            node:loadTexture("koko/atlas/all_common/title/0002.png", 1)
        else
            node:loadTexture("koko/atlas/all_common/title/0001.png", 1)
        end
        txt:setPositionX(node:getContentSize().width/2)
    end
end

function ctrl:left_bar1()
    self:showPage(1)
    self:switchBar(1)
end

function ctrl:left_bar2()
    self:showPage(2)   
    self:switchBar(2)
    self:refresh2(self.probleScroll)
end

function ctrl:left_bar3()
    self:showPage(6)
    self:switchBar(3)   
end

function ctrl:contactCustomer()
    self:showPage(3)
end
function ctrl:sendErrText()
    --发送错误报告
    local errType = 3
    local uid = CC.Player.uid
    local gameStr = "platform"
    local gameId = CC.GameMgr.Scene.iGame
    if gameId then
        local tbl = CC.Excel.GameList[gameId]
        if tbl then
            gameStr = tbl.LocalDir
        end
    end
    -- local errContent = read_latest_log(10240)
    -- kk.util.sendErrorReport(errType, uid, gameStr, errContent, "玩家主动上传错误报告", function(rsp)
    --     if rsp.success then
    --         kk.msgup.show("发送错误报告成功")
    --     else
    --         kk.msgup.show(string.format("上传日志失败：%s", rsp.message))
    --     end
    -- end)

    --老的错误报告
    _G.upload_game_log("koko游戏", "来宾655400", function(result)
        if result == 1 then
           kk.msgup.show("发送成功")
        else
           kk.msgup.show("发送失败")
        end
    end)
end

--联系客服页面
function ctrl:refresh3(sv)
    local tval = txtPhone[platform_iswin32()]
    local kScroll = CC.ScrollView:Create{Node = sv}
    CC.Node:Array{Node = kScroll.kNode:findChild("item1"), X = 1, Y = #tval, XD = 83, YD = 79}
    kScroll:Fix()
    for i = 1, #tval do
        local node = sv:findChild("item"..i)
        node:findChild("text"):setString(tval[i][1])
        node:findChild("btnPhone"):loadTexture(tval[i][2], 1)
        node:findChild("btnPhone"):setTag(i)
        node:findChild("btnPhone"):onClick(handler(self, self.onPhone), 1.03)
        node:findChild("btnPhone"):setVisible(tval[i][5])
    end
end
function ctrl:onPhone(sender)
    local idx = sender:getTag()
    local tVal = txtPhone[platform_iswin32()]
    for i = 1, #tVal do
        if  i == idx and type(tVal[i][3]) == "function" then
            tVal[i][3](tVal[i][4], tVal[i][6])
        end
    end
end

--服务协议页面
function ctrl:refresh4()
    local protocolSv = self:getNode():findChild("panel/panel4/scrollView")
    local txtNode = protocolSv:findChild("text")
    local sz = protocolSv:getInnerContainerSize()
    local a = txtNode:setStringWithAutoHeight(protocolTxt)
    sz.height = math.max(protocolSv:getContentSize().height, a)
    protocolSv:setInnerContainerSize(sz)
    txtNode:setPositionY(sz.height)
end

--意见反馈页面
function ctrl:adviceEdit()
    local node = self:getNode():findChild("panel/panel5/idea")
    local si = node:getContentSize()
    local ideaNode = _G.kk.edit.createAny(si, "请输入", nil, true)
    ideaNode:setName("ideaNode")
    ideaNode:setPlaceholderFontColor(cc.c3b(0x81, 0x2e, 0x03))
    ideaNode:setPosition(cc.p(0, 0))
    node:addChild(ideaNode)
end

function ctrl:onSubmit(sender)
    local node = self:getNode():findChild("panel/panel5/idea/ideaNode")
    local content = node:getText()
    if content == "" or content == nil then return end
    if string.utf8len(content) >= 50 then kk.msgup.show("您输入超过50!") return end
    web.sendComplaintReq(CC.Player.appKey, CC.Player.uid, content, function(t)
        if t.success == true then
            node:setText("")
            kk.msgup.show("提交成功!")
        else
            kk.msgup.show("提交失败!")
        end
    end)
end

--常见问题
function ctrl:refresh2(sv)
    if sv:getChildrenCount() == 0 then
        local minHeight = sv:getContentSize().height
        sv:setInnerContainerSize(cc.size(_svProblemWidth, math.max(minHeight, _count * _svProblemHeight)))
        for i = 1, _count do
            local item = self:problemItem(i)
            self:addToItemView2(sv, item)
        end
    end    
end

function ctrl:addToItemView2(sv, item)
    local count = sv:getChildrenCount()
    local size = sv:getInnerContainerSize()
    local pos = cc.p(0, size.height - (count + 1) * _svProblemHeight)
    item:setAnchorPoint(0, 0)
    item:setPosition(pos)
    sv:addChild(item)
end

function ctrl:problemItem(i)
    local problem = ccui.Layout:create()
    problem:setName("item"..i)
    problem:setAnchorPoint(0, 0)
    problem:setContentSize(cc.size(_svProblemWidth, _svProblemHeight))
    problem:onClick(handler(self, self.onProblemDetails), 1)
    problem:setBackGroundImage("koko/atlas/all_common/title/2011.png", 1)

    --图标
    local icon = ccui.ImageView:create()
    icon:setName("icon"..i)
    icon:loadTexture("koko/atlas/customer_service/2015.png", 1)
    icon:setAnchorPoint(0, 0.5)
    icon:setPosition(cc.p(30, problem:getContentSize().height / 2))
    problem:addChild(icon)

    --文本
    local txt = cc.Label:create()
    local ttf = {}
    ttf.fontFilePath = "font/system.ttf"
    ttf.fontSize = 24
    txt:setTTFConfig(ttf)
    txt:setAnchorPoint(0, 0.5)
    txt:setName("txt")
    txt:setString(problemTxt[i][1])
    txt:setTextColor(cc.c3b(0x81, 0x2e, 0x03))
    txt:setPosition(cc.p(120, problem:getContentSize().height / 2))
    problem:addChild(txt)

    --按钮
    local btndown = ccui.ImageView:create()
    btndown:setName("down"..i)
    btndown:loadTexture("koko/atlas/customer_service/2013.png", 1)
    btndown:setAnchorPoint(0, 0)
    btndown:setPosition(cc.p(680, 17))
    btndown:onClick(handler(self, self.onProblemDetails), 1)
    problem:addChild(btndown)

    return problem
end

function ctrl:problemItem2(i)
    local problem = ccui.Layout:create()
    problem:setName("item"..i)
    problem:setAnchorPoint(0, 0)
    problem:setContentSize(cc.size(_svProblemWidth, _svProblemHeight2))
    problem:setBackGroundImage("koko/atlas/customer_service/2012.png", 1)
    problem:setBackGroundImageScale9Enabled(true)
    
    local txtDescript = ccui.Text:create("hello", "font/system.ttf", 24)
    txtDescript:setAnchorPoint(0, 0)
    txtDescript:setName("txtDescript")
    txtDescript:setTextColor(cc.c3b(0x81, 0x2e, 0x03))
    txtDescript:setPosition(cc.p(50, 0))
    txtDescript:setTextAreaSize(cc.size(_svProblemWidth2 - 100, 0))
    local a = txtDescript:setStringWithAutoHeight(problemTxt[i][2])
    problem:setContentSize(cc.size(_svProblemWidth, a + 88))
    problem:addChild(txtDescript)

    --小条背景
    local bg = ccui.ImageView:create()
    bg:setName("bgxx"..i)
    bg:loadTexture("koko/atlas/all_common/title/2011.png", 1)
    bg:setAnchorPoint(0, 1)
    bg:setPosition(cc.p(0, problem:getContentSize().height))
    bg:onClick(handler(self, self.onProblemDetails2), 1)
    problem:addChild(bg)

    --图标
    local icon = ccui.ImageView:create()
    icon:setName("icon"..i)
    icon:loadTexture("koko/atlas/customer_service/2015.png", 1)
    icon:setAnchorPoint(0, 0.5)
    icon:setPosition(cc.p(30, problem:getContentSize().height - bg:getContentSize().height / 2))
    problem:addChild(icon)

    --文本
    local txt = cc.Label:create()
    local ttf = {}
    ttf.fontFilePath = "font/system.ttf"
    ttf.fontSize = 24
    txt:setTTFConfig(ttf)
    txt:setAnchorPoint(0, 0.5)
    txt:setName("txt")
    txt:setString(problemTxt[i][1])
    txt:setTextColor(cc.c3b(0x81, 0x2e, 0x03))
    txt:setPosition(cc.p(120, problem:getContentSize().height - bg:getContentSize().height / 2))
    problem:addChild(txt)

    --电话按钮
    local btndown = ccui.ImageView:create()
    btndown:setName("down"..i)
    btndown:loadTexture("koko/atlas/customer_service/2014.png", 1)
    btndown:setAnchorPoint(0, 0)
    btndown:setPosition(cc.p(680, a + 17))
    btndown:onClick(handler(self, self.onProblemDetails2), 1)
    problem:addChild(btndown)

    return problem
end

function ctrl:clickRefresh()
    local sv = self.probleScroll
    local totalheight = 0
    for i = 1, _count do
        local l = sv:findChild("item"..i):getContentSize().height
        totalheight = totalheight + l
    end
    local maxheight = math.max(sv:getContentSize().height, totalheight)
    sv:setInnerContainerSize(cc.size(_svProblemWidth, maxheight))

    local height = 0
    for i = 1, _count do
        local node = sv:findChild("item"..i)
        local l = node:getContentSize().height
        height = height + l
        node:setPositionY(maxheight - height)
    end

    -- --计算滚动后的新位置
    local scrollAreaHeight = maxheight - sv:getContentSize().height
    local a = self.marginY <= scrollAreaHeight and self.marginY * 100 / scrollAreaHeight or 100
    sv:jumpToPercentVertical(a)  
end

function ctrl:onProblemDetails(sender)
    local downx = sender:getName()
    local i = tonumber(string.sub(downx, 5))
    local layoutNode = self.probleScroll:findChild("item"..i)
    local index = 1
    
    --缓存下边界距离
    local vec = self.probleScroll:getInnerContainerPosition()
    local sz = self.probleScroll:getInnerContainerSize()
    local a, b= layoutNode:getPosition()
    self.marginY = sz.height + vec.y - self.probleScroll:getContentSize().height
    if i == 4 then
        self.marginY = self.marginY + 180
    end    

    layoutNode:removeFromParent()  
    local node = self:problemItem2(i)
    self.probleScroll:addChild(node)
    self:clickRefresh()
end

function ctrl:onProblemDetails2(sender)
    local vec = self.probleScroll:getInnerContainerPosition()
    local sz = self.probleScroll:getInnerContainerSize()
    self.marginY = sz.height + vec.y - self.probleScroll:getContentSize().height

    local downx = sender:getName()
    local i = tonumber(string.sub(downx, 5))
    self.probleScroll:findChild("item"..i):removeFromParent()

    local node = self:problemItem(i)
    self.probleScroll:addChild(node)
    self:clickRefresh()
end
--关于我们
function ctrl:refresh6()
    self:getNode():findChild("panel/panel6/text"):setString(WithMeTxt)
end

return ctrl