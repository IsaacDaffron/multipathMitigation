function [Y,Xf,Af] = NN1_10MHz_nnfunc(X,~,~)
%MYNEURALNETWORKFUNCTION neural network simulation function.
%
% Auto-generated by MATLAB, 01-Mar-2019 08:24:02.
%
% [Y] = myNeuralNetworkFunction(X,~,~) takes these arguments:
%
%   X = 1xTS cell, 1 inputs over TS timesteps
%   Each X{1,ts} = 65xQ matrix, input #1 at timestep ts.
%
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = 1xQ matrix, output #1 at timestep ts.
%
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

% ===== NEURAL NETWORK CONSTANTS =====

% Input 1
x1_step1.xoffset = [0.000863602507350327;0.00060843621848301;0.00126634074449288;0.00565698108993441;0.00628394479467311;0.0151479140736042;0.00751880075504424;0.0109990767140807;0.0121119325894457;0.0109863570362633;0.00436254129267122;0.0035290126163207;0.00387510439337078;0.00330211322535994;0.00165385475766044;0.000779917198403727;0.0011818274813581;0.0019991315751865;0.00476730627982058;0.00392162528478977;0.00535431066671342;0.0243870824795511;0.0498218265001639;0.160717198267989;0.181454016006209;0.195221687180947;0.232604518160424;0.256230618817122;0.262098179230227;0.265917359064951;0.266961883528692;0.264678761030376;0.256734909507794;0.242835897033011;0.224558930147991;0.203720849762764;0.182231732931456;0.161008253230946;0.13918227641629;0.119354045496994;0.108334931531031;0.114094365328429;0.0749617980725307;0.00847384223822473;0.00516427584243293;0.0060690129979448;0.00361514266124351;0.00587160189417617;0.00159221854897408;0.00101485483322137;0.00220038868582324;0.0049251582011072;0.00890282179103311;0.00182463703851262;0.00620801014309831;0.00481755924586626;0.00875696033041658;0.00331481631326413;0.0210497773754353;0.00839705261069278;0.00555593577820401;0.0055692900768487;0.00110057702015151;0.00226805168749555;0.000553482607934872];
x1_step1.gain = [4.22096129236631;4.20164048379398;3.70773723013763;3.22284289388784;2.84581599243403;2.59178395988497;2.35587383498162;2.21503579984027;2.1197023963728;2.06440850188433;2.03770835274011;2.02208763416357;2.03812141382839;2.04647556685012;2.07607706465922;2.05219576786155;2.03486992445102;2.03597918204354;2.05446883682337;2.07408110145028;2.09892023280747;2.15854708574151;2.19079606564877;2.45747788350592;2.48069676888771;2.49870975205758;2.60886002482825;2.69023205119443;2.71498195605982;2.73171371574129;2.73286442742228;2.71990362316076;2.69082999535947;2.64144196092025;2.58064622334338;2.51950642515137;2.47298365139254;2.41204812520703;2.35690143134249;2.32053389559509;2.29275951697791;2.30477889847915;2.21144995143586;2.0562062554586;2.05004383423641;2.04439497928563;2.0361086807835;2.05580140080504;2.02642350223121;2.01514582144727;2.0091790283974;2.02007876172572;2.02825480357208;2.01846965925102;2.0276982328315;2.0178568066936;2.0375497618636;2.07321390737372;2.2013339369141;2.30425803497915;2.48728857417387;2.75098550151234;3.08107230544905;3.47846840159011;3.77557095623963];
x1_step1.ymin = -1;

% Layer 1
b1 = [-9.8541918291926009488;0.10293250935959351311;-1.4253440287209906412;-6.3939533484703803268;7.9067545426796517205;-1.6961002971058971589;1.5573409598386047659;-4.1809815984069134132;-5.1069088228681813746;-8.2824207395136930643];
IW1_1 = [-6.0422878358020533085 4.9907731370509340607 5.8393912115624644343 -0.83276734272868302433 2.4186191416371514151 -2.9533733899774587961 -10.294550248666327619 3.3096424811414184575 4.487146897112920918 -1.5230905063612114603 -3.8769692909350426113 1.4875111980687503177 0.86300969748574618556 -1.1553113043282561279 -2.6663087484169789576 2.4483521507597512112 4.3432703234263270176 -5.0678421005419496126 -2.2001820045682363158 5.8251001790575180905 -0.26513225635486625809 -4.042667414920183333 6.0454280586789792551 -3.1556511651517684669 -5.9334884942369701122 -2.4170191654194099762 2.0471427580308194649 2.4222134323848276694 0.045158802220214601386 -1.5276460217275740217 -1.3265202060539071915 -0.14445819580362370682 2.9538818259239625341 1.931531296099271211 -1.3963663157505254997 -3.4932195633660549916 0.9154743935474641825 5.4165715776798313286 2.6757274345135764193 -2.6003241978906554976 -6.9519670377570390585 -8.0917655612712344748 -4.4781074722753260176 2.6325790524976131479 14.025583468529516651 4.980383913603689372 -0.36733338339277471496 -3.8029464421511947059 -2.7060034118158697858 -5.311683585329671331 2.1023671267237262761 1.2564017961535858259 0.5710497590594589834 4.2803702238717828976 -1.8211166707225554529 -5.4979560730982068861 -2.5361076266845281602 1.3473990927698531461 6.9353622888769361765 9.1169270129291763993 -5.4918771382400883851 -15.770358548854801484 -3.0225718010945668013 23.361353829922993697 -9.679329998005949065;-2.9534891479681713022 2.7972655363268010831 -0.23846588912159802365 -2.0420254772645041186 -1.6014071361126527293 4.2288741782261807245 -5.4288791441743047272 -0.18369794288764229595 4.7082315766576821048 6.3232066233811661249 0.20852168067212606406 -4.2621621896538917085 -0.94012549036454229334 -3.3422863947535645934 3.6260091612846112596 0.74177988505037550926 -1.6296498553713141266 -0.73112047640998922837 2.8651973162780621784 2.8811349241723629433 3.339747488452520674 -11.380599048445567689 2.1214708167569185093 -1.1184472967970244817 1.1063936326992196424 1.7648276508956737274 4.1434099710013931883 4.0012873825231869418 2.4322586932798948567 -1.8234579619761410729 -3.7330692302351313749 -3.4508251778305489843 -2.5229726764524018634 -4.5916840825345381916 -5.2331572758413642532 2.0853976387943089499 9.9147896882713588695 9.4015552986012735914 3.4345933846099265807 -4.5644438004611718185 -5.8016442230786751111 -0.93959247413988078446 -3.0572424074035451369 -1.7992758465254425904 5.9839298819649657801 0.66843788774790335872 -1.3125687070924620947 -1.1247723628226433679 3.4376989483001176851 0.14386961833497494134 -2.2256618629856714797 0.64497535569708497327 -4.9147247636856361552 2.6357641279895958064 2.5244509582138214832 -1.0818230552952021739 -0.91184347161552836702 -2.1582896312556774099 1.0537348418978809139 0.23024574411581896771 -0.43524458258941284283 -1.8676449230413691982 -4.3647760196833322865 9.6184809340681116652 -4.0798836422782045474;3.5875644833122870558 -4.7388940259253287124 5.3817207342528341485 2.8744826698461403147 5.9086105794590979556 1.2799374277039157199 -20.124813472271409154 -3.3560557255555214518 4.8878989385680968738 8.4031280339063503249 -3.8051416201052332688 0.4714808543879548397 2.9009413599982241116 -3.0259688904319248515 -0.49649635481232395895 0.4522960949673516251 4.7878029137045228225 -2.2336618728629367148 -1.3487484366010131787 3.7627885164805299212 1.993108105234107752 -14.581150398498991194 12.705762471796667512 7.1295246366602205157 -3.729186853734492324 -6.8271151123572444419 -7.7794699833969787051 4.5550986966578799198 -0.87471439170105624861 0.14645118130864856476 -1.0809255713996224202 5.4827427717262144924 9.4363647948984255009 5.1230261182902490091 -1.9794838372935406046 -3.5557002837241880044 -5.8629131801848881622 -2.692028671413996932 -4.8520064543384471278 -1.2881842028432179958 5.9784904774186511389 1.4075429101037526536 4.9363198065399567227 -3.9530607003364570673 5.3432521202865013166 -6.2145939354893044992 1.4860868955064152619 0.65113005853760952402 -3.7701006803450982652 3.0011973582523485682 -2.941440267958485677 6.701174702842142672 -4.4421992502843350437 -0.40352509450192358686 2.3931546157573806433 -0.01448275821947593231 0.13796942344523308033 0.8700145642778439603 -2.7478961542642568183 -0.020196665141012967726 2.9801004906645669479 -1.0146861986440307568 7.1886617041343585655 -12.863084427794175824 4.0791008986189831731;-0.76023750001575629565 -1.6025112325750554554 -2.0520010227678611159 -2.5558190963316111954 -0.96640786851881488317 2.2810286745886538817 4.4862875197677247741 4.8741937221138318392 3.5927610110944336874 2.6918174549457329903 1.566167892809594564 0.041158242093491621827 -1.3612378738011927659 -2.3379698895081082455 -1.1856285214288937446 1.5443721862571331283 -0.56598117896859212461 -3.3072344084856837299 -2.8082207169748452102 -2.457191663766586931 -2.4212421756806969952 0.048815688525351855209 -0.7057005375388043511 0.62936133345827804941 2.0215298826523930842 3.0889255912084947475 3.563712009809017367 2.6609407699121194746 1.1044985023838398419 0.072167799863026863005 -0.58275413228498107454 -0.92409024143076379243 -1.8351838901327539588 -2.1401674572748139447 -1.5419117243838948994 -0.12234544395638141667 1.4968069749944943325 2.858991556937136469 2.5744036593475212449 1.9403660802495918958 0.81189027439502825523 1.1919153787707852388 1.0292178702140251101 0.839488793215743212 -1.1558927800753542314 -1.8784659048204723764 -2.3625583109946446392 -0.93919164069346561252 0.2991376150160922065 0.81787577684303114367 0.20192276689596538874 -0.94596514093246786281 -1.5129484219773587927 -1.1665578576868838034 -0.60441059292987620033 0.1669525117164979422 0.30556319442246709928 0.83578187931406122679 1.654050082392196197 1.4315232023516648585 -0.26276756049167082629 -1.8762227952147898513 0.9815357781560836159 5.2111340384991242658 -2.6960774063670687184;0.051898204936769644358 4.9753855193387463984 8.2441645296136929488 5.3235732149072907404 1.1312215209055647147 -3.2084468077925976104 -5.3013404999207320856 -4.526630455781795348 -3.7300846690025784014 -2.1535640527592887494 -1.1795790660245879522 -0.71153317415580563665 -0.98827426975029486478 -0.56598156484816219969 2.5488958652177844399 2.5267792781983127171 1.5846494189843198797 -1.1085805402248232188 -6.8046347837631850908 -8.4298655118088383631 -7.4764732602785137772 -4.4920554392745710715 -2.3015865197165323863 -2.5204865284863950947 -1.5322375121400080289 -0.67057349140171074175 0.30926489068678419958 1.0830909769552019561 2.2140711334804485944 2.5328255266718135985 2.6186678844156983104 2.402528210103767492 1.207022828088342381 0.41147556890790448758 -1.4819186569445086388 -3.0899237819494347335 -3.9071099988811304193 -4.7320479567278423971 -4.2451620993678309546 -3.5457159109478046943 -2.6573886135800361963 -1.9488326401770568186 0.042045311226217990663 1.4452126354758292326 1.6648202970538943379 0.025153082719858169819 -3.6170705243886582814 -0.41429118536658615657 3.2784652878878834947 4.1134864094037961735 2.8633769019732633332 0.36329098449346708399 0.47300887836152993859 0.89113048653702642277 0.51360139195883991459 -0.49602152772630109245 -1.2392654051159350814 -1.607511993514908033 -0.65708146390154975602 1.3879385028949562386 5.1497058544419420656 5.4212695668584673925 -0.13545996754997052802 -6.138954232190340754 5.0946007779427890938;-0.38801053842469035438 0.71459409427149900296 -1.0781911001894783908 -1.4114259209599833156 8.7862147923947251371 -8.1818900871964768129 -4.9637440450125884794 6.0655859087932544327 -0.75846187562272016081 -1.3406981975804164176 2.3132946845669741798 0.70186387124046878405 -1.0842675668704790937 -0.28801030465648230772 -1.1656283044599096144 1.1714647838130316515 -0.78682666091876773962 -3.4729934701641194117 5.5204494430388297843 5.1727904856634721042 -10.692525487948875806 -2.8344982886377318998 8.1345670265243725794 -2.1572153707062535766 -2.5007449402082415624 0.87516700248728884759 -0.45948553511372253189 2.3972252767839794529 -2.0827448228327147817 0.73766203805302443808 -1.4694032413078701449 0.77015876495902568788 2.9970381553653484552 -0.93061711849372064087 -6.0876986376016066771 1.8105891946432330908 0.65630457617732884668 -1.2251046045829361297 0.58270960160305607101 3.9263653759831713685 1.8673052421736124895 0.95097135010136724098 -1.3361311649434186588 -5.2376593147985950338 -0.17447266236365216452 -0.64788638450184621309 4.2891908287783762077 -3.296266362780075454 -0.09366843328381996292 0.64968320449377281456 2.1870716895905504273 -1.587555699158658129 -0.40603289391521363294 0.019201188459023632582 -0.21829498256422963376 2.7864574569197997356 4.2510756547555086371 -2.9286751909155297469 -1.0832548653396143479 -3.8551262576907703306 5.2458813305249645254 0.0842903981676198788 -2.1914273193971065545 4.2364476695194372979 -1.8112381487533653068;-0.91873194505927546771 2.5701073360452637573 0.46303825881961446775 -2.645647093905666658 -11.629280366897727816 4.5712664554317017362 12.657563230666315945 4.9528620434264585271 -7.6415073422531722969 -1.5830768523299307837 -2.7620058952904900096 0.99575074735829860462 2.6683215258875390141 -3.083062990034215467 2.7885227908639458327 -1.5130968965819104888 -2.4477708162074161002 -0.48402306803936756552 -2.7600582586911963645 -6.5197992509683091455 13.313315229443018595 -9.6933243498162511287 1.2551276250862528627 -3.0864889771371055716 -0.15599155249064108886 4.676427614017647727 4.340757949423458939 2.9012386996335108869 -0.83163766599513488931 -3.210538444342253328 -0.36926565149092105411 -0.54399018973932034005 -4.0947206700362626108 -5.4687881355732361754 -2.6015784955756218189 1.0137084425151701161 3.3377803006209054715 6.8452859734865079133 5.0950116263411890927 -3.4037454554805934848 -4.0487043509925664253 2.0515027022893344011 1.2940646324693381164 -8.2165527110732803351 6.379016932491769154 -3.6142807680991730912 1.1907715423388340881 -0.07241388571154686038 2.9859365871769574241 -1.4509922594788600136 0.97633348438929001833 1.520504283501613374 -2.0705170603779268212 1.8830026952734739698 -0.16234603594219232381 -1.3219459109132007946 -3.7308424478568666949 4.119442180315515678 0.81939392730090310213 0.069239406843818476767 1.0644952367829976225 1.3520995416133689826 -6.0193759906088626366 5.567344881353569086 -1.3125733118707836322;-2.0355557593552693341 1.1127772468717156418 0.87463740993423766401 -6.7383852538076487448 0.18039715119685270639 -0.37899181613706162119 3.9129813043893415525 13.219590272413231702 -7.25671989562678732 -9.3760484119273392878 0.33770863591065675147 1.4156130638621582385 3.0154325306975326981 -0.88492603787281320926 1.2192613442032702586 -1.83118113406726013 -0.81838882384620104116 -2.7029110404946798951 -0.79350698832919697168 -0.99837963790186934343 17.817131659447571934 -3.2244810200453510873 -12.015422041848287549 -4.0354030540945213801 3.5526363879864484296 3.6057800833285194031 -0.67553479103600921896 -1.8722970489467731792 1.2086284585044857476 3.1428658949504786335 2.1136149176695604446 1.5129775494824615478 0.25881364685479046894 -0.77437418403113766896 -2.5398629570801998234 -3.4721300913613886152 0.7280570567105666413 5.829945389450380766 4.9790592297736404603 -0.33508862955093010605 -4.2216601494306802422 -3.0322524848245215878 3.5724774338605400636 0.93078276439927132291 4.592305068308808913 -3.7663230077362497283 0.75027764981454447835 2.6225638482848334654 0.78806289253242922666 -1.7408108225937102276 -0.68794893001008394773 2.7924745919925428872 -1.7625533100958123978 1.273841544002574766 -1.1042908378429354688 -1.9550427114716462107 -0.0088348660046107668764 0.63982854691310953044 -1.4343531307002774788 1.1488278368645452598 2.345462612766164856 -0.1460704576695969481 -1.4775199842025774633 -2.4277258526360530055 2.1570420920562471956;2.9437845779881954833 -1.1647562712701846621 1.8391428180927369418 0.78827166909833790154 2.3410455366364004703 -0.2017816058765192766 -0.48704740871051699358 -7.263341896678979559 0.32489868898780349671 -0.15003289091928700971 2.9046732987956502825 -0.66858755569389505258 1.8402944621660859426 -0.96472329835424031064 1.5846694688219764569 -1.3206611572689963552 2.092229400237566761 1.2309323250639732095 -3.104970588330206116 -3.5697729677048624097 10.728068865497103701 -12.9572067483910498 8.3682184078176184983 0.71110279963344458221 2.8788854215813892701 -2.8272731333913392326 -7.9050917349422977765 -0.082979957634189083215 -2.6495413146988062714 5.9265205372055120847 -0.91615207424149580628 1.8289371633762530056 1.8356878216442928942 1.6829860817355870584 -0.31427771106709090354 2.6168865681436757065 -4.5908332503590498774 -9.3520600872268619952 -1.7035368606396226188 2.2572803214419256967 0.37655556651826693759 1.529283842601035559 6.3225528571471292238 0.063639563958706249491 -5.2222489965009959434 1.3270590996132287653 1.8748349477732233481 -1.7158041998915189996 -1.4276025715126885451 2.14193795515466201 -1.1060592446009176459 1.2541271001931151297 -0.74831489718997412641 0.827514019684540858 0.73169769017381003362 -2.671360787467036868 0.28918764440350708256 -0.012697551713269202012 2.8692149580229888706 0.25517091262068769542 -0.32859857350395316189 -0.94661662335707874583 5.6209988633008425296 -9.9814693565984207169 3.4731662976141230992;0.12638911856944137768 -2.6908968272454232284 -1.2134744709016380693 -0.74696274573800225394 2.7521142603033394991 -0.36869167082079323805 2.1517882069652838339 3.0987884652316655121 1.7631591946560400963 2.2653266800945242032 3.260925955851662561 0.71778633497812482922 1.3004352543462263103 1.1060888550916192496 -0.4772517386278010143 0.20853872047052529615 0.87567119402558890595 2.0460670644453284872 1.1077463396487998715 1.0634923965185454353 2.4748628452980159231 -0.071291991955446679108 -3.9701488953324064468 -0.32667734062229758507 2.0858599446609620287 -1.4203920035829395996 -3.8213322922413963667 -0.18380911217870443686 2.5877393939568746895 1.0598879734838912992 -0.28246488576532663428 1.330844993552368738 2.2906266986279839593 2.5140389687818838205 1.380105506391599679 1.2828767934924694138 1.7194231404809561248 -0.21235531346922070783 -0.85251332812345426149 1.1757806727298028004 1.9793697133020453638 0.5302876446591245907 0.8398262859923038004 1.150354021646089242 -1.8071610488518594639 0.68094232350940631093 0.25467093012139269126 -1.4289003047336841234 -2.3112711017316125428 -3.1263063278470921702 -0.37951167842045718803 -1.4905470221272145714 2.2145079760916321909 1.6015361226960271868 0.20298428732474158021 0.29713153574079720354 0.71169441201362992899 1.0119048729652440066 0.66140985865696722001 0.54699759340758946635 0.5315047947666302619 -1.3779244531795802331 -2.5019398991466323956 -1.3299639987977538436 0.87059013335722990057];

% Layer 2
b2 = -0.4384675501742553716;
LW2_1 = [0.5883748559208994422 -8.3544993555821056293e-05 -1.265771856352544424e-06 -2.9034480907182142465e-06 -7.2602651242991634431e-06 0.00011245815962013269002 0.000157163999124618122 4.6592161046939039779e-05 -0.96999048608704652175 -0.00015840884278324707203];

% Output 1
y1_step1.ymin = -1;
y1_step1.gain = 5.18831770499419e-05;
y1_step1.xoffset = -18150.3650773213;

% ===== SIMULATION ========

% Format Input Arguments
isCellX = iscell(X);
if ~isCellX
    X = {X};
end

% Dimensions
TS = size(X,2); % timesteps
if ~isempty(X)
    Q = size(X{1},2); % samples/series
else
    Q = 0;
end

% Allocate Outputs
Y = cell(1,TS);

% Time loop
for ts=1:TS
    
    % Input 1
    Xp1 = mapminmax_apply(X{1,ts},x1_step1);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1);
end

% Final Delay States
Xf = cell(1,0);
Af = cell(2,0);

% Format Output Arguments
if ~isCellX
    Y = cell2mat(Y);
end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings)
y = bsxfun(@minus,x,settings.xoffset);
y = bsxfun(@times,y,settings.gain);
y = bsxfun(@plus,y,settings.ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n,~)
a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings)
x = bsxfun(@minus,y,settings.ymin);
x = bsxfun(@rdivide,x,settings.gain);
x = bsxfun(@plus,x,settings.xoffset);
end