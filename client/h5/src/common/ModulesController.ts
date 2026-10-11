import { GhostWalkController } from "./../commonController/GhostWalkController"
import { MainStrongerController } from "./../commonController/MainStrongerController"
import { BannerController } from "./../commonController/BannerController"
import { Util } from "../util/Util"
import { SceneController } from "../scene/SceneController"
import { FightController } from "../scene/fight/FightController"
import { AutoFightController } from "../autofight/AutoFightController"
import { SkillController } from "../skill/SkillController"
import { ViewManager } from "./ViewManager"
// import { StoryAnimationController } from "../storyAnimation/StoryAnimationController"
import { BagController } from "../commonController/BagController"
import { CheatController } from "../commonController/CheatController"
import { GoodsController } from "../commonController/GoodsController"
import { EquipController } from "../commonController/EquipController"
import { MainUIController } from "../commonController/MainUIController"
import { TaskController } from "../commonController/TaskController"
import { StoryController } from "../commonController/StoryController"
import { SevenDayController } from "../commonController/SevenDayController"
import { ItemUseController } from "../commonController/ItemUseController"
import { DialogueController } from "../commonController/DialogueController"
import { DragonBallController } from "../commonController/DragonBallController"
import { GuardController } from "../commonController/GuardController"
// import { MainUIController } from "../commonController/MainUIController"
import { CustomActivityController } from "../commonController/CustomActivityController"
import { attributePotionController } from "../commonController/attributePotionController"
import { RevelationController } from "../commonController/RevelationController"
import { HolySealController } from "../commonController/HolySealController"
import { OutWardController } from "../commonController/OutWardController"
import { IllusionController } from "../commonController/IllusionController";
import { RuneController } from "../commonController/RuneController"
import { PetEquipController } from "../commonController/PetEquipController"
import { DsgtController } from "../commonController/DsgtController"
import { MedalController } from "../commonController/MedalController"
import { MonBookController } from "../commonController/MonBookController"
import { ShopController } from "../commonController/ShopController"
import { LungController } from "../commonController/LungController"
import { ArmorController } from "../commonController/ArmorController"
import { FashionController } from "../commonController/FashionController"
import { PartnerController } from "../commonController/PartnerController"
import { PartnerAwakeController } from "../commonController/PartnerAwakeController"
import { GuildController } from "../commonController/GuildController"
import { GodBeastController } from "../commonController/GodBeastController"
import { SettingController } from "../commonController/SettingController"
// import { longlangController } from "../commonController/longlangController"
import { DressController } from "../commonController/DressController"
import { UnrealController } from "../commonController/UnrealController"
import { DemonController } from "../commonController/DemonController"
import { StarEquipController } from "../commonController/StarEquipController"
import { chcController } from "../commonController/chcController"
import { GodBefallController } from "../commonController/GodBefallController"
import { MapController } from "../commonController/MapController"
import { VipController } from "../commonController/VipController"
import { RedPacketController } from "../commonController/RedPacketController"
import { CompositeController } from "../commonController/CompositeController"

import { PushGiftController } from "../commonController/PushGiftController"
import { PkStatusController } from "../commonController/PkStatusController"
import { FriendController } from "../commonController/FriendController"
import { FirstRechargeController } from "../commonController/FirstRechargeController"
import { MarketController } from "../commonController/MarketController"
import { BaseDungeonController } from "../commonController/BaseDungeonController"
import { FirstBloodController } from "../commonController/FirstBloodController"
import { GuildActivityController } from "../commonController/GuildActivityController"
import { ChatController } from "../commonController/ChatController"
import { RuneTreasureController } from "../commonController/RuneTreasureController"
import { KaifuActivityController } from "../commonController/KaifuActivityController"
import { MarriageController } from "../commonController/MarriageController"
import { HolyTerritoryController } from "../commonController/HolyTerritoryController"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { BossController } from "../commonController/BossController"
import { ReliveController } from "../commonController/ReliveController"
import { GuildFightController } from "../commonController/GuildFightController"
import { BrightSeaController } from "../commonController/BrightSeaController"
import { TeamController } from "../commonController/TeamController"
import { MondaysAwardController } from "../commonController/MondaysAwardController"
import { SuitActivityController } from "../commonController/SuitActivityController"
import { KfHolyAreaController } from "../commonController/KfHolyAreaController"
import { BabyController } from "../commonController/BabyController"
import { RankController } from "../commonController/RankController"
import { NineSkyController } from "../commonController/NineSkyController"
import { FunctionOpenController } from "../commonController/FunctionOpenController"
import { ActivityForeshowManager } from "../commonModel/ActivityForeshowManager"
import { SnatchTreasureController } from "../commonController/SnatchTreasureController"
import { WelfareController } from "../commonController/WelfareController"
import { PrayController } from "../commonController/PrayController"
import { DungeonPartnerController } from "../commonController/DungeonPartnerController"
import { DailyController } from "../commonController/DailyController"
import { DepositController } from "../commonController/DepositController"
import { HolyBattleController } from "../commonController/HolyBattleController"
import { TopPkController } from "../commonController/TopPkController"
import { kfSingleRankController } from "../commonController/kfSingleRankController"
import { ReincarnationController } from "../commonController/ReincarnationController"
import { NoonPartyController } from "../commonController/NoonPartyController"
import { BanquetController } from "../commonController/BanquetController"
import { TempleAwakenController } from "../commonController/TempleAwakenController"
import { achvController } from "../commonController/achvController"
import { ArenaController } from "../commonController/ArenaController"
import { DiamondFightController } from "../commonController/DiamondFightController"
import { OutLineController } from "../commonController/OutLineController"
import { FriendInviteController } from "../commonController/FriendInviteController"
import { TopVipController } from "../commonController/TopVipController"
import { SurpriseGiftController } from "../commonController/SurpriseGiftController"
import { Kf1vnController } from "../commonController/Kf1vnController"
import { AttentionController } from "../commonController/AttentionController"
import { FestivalController } from "../commonController/FestivalController"
import { EternityController } from "../commonController/EternityController"
import { LimitLevelShopController } from "../commonController/LimitLevelShopController"
import { GodCourtController } from "../commonController/GodCourtController"
import { CompeteListController } from './../commonController/CompeteListController'
import { TSCrackController } from "../commonController/TSCrackController"
import { kfStageController } from "../commonController/kfStageController"
import { MaskController } from "../commonController/MaskController"
import { HotPointController } from "../kfHotPoint/HotPointController"
//import { SeaHegemonyController } from "../commonController/SeaHegemonyController"
import { longlangController } from "../commonController/longlangController"
import { SeaHegemonyController } from "../commonController/SeaHegemonyController"
import { DragonWhisperController } from "../commonController/DragonWhisperController"
import { AdventureController } from "../commonController/AdventureController"
import { ListDuobaoController } from "../commonController/ListDuobaoController"
import { GrowthBenefitsController } from "../commonController/GrowthBenefitsController"
import { TreasureMapController } from "../commonController/TreasureMapController"
import { SentientActController } from "../commonController/SentientActController"
import { AddVipServiceController } from "../commonController/AddVipServiceController"
import { CycleimpActlistController } from "../commonController/CycleimpActlistController"
import { WeekCardController } from "../commonController/WeekCardController"
import { AutoBrushController } from "../commonController/AutoBrushController"
import { MonsterController } from "../commonController/MonsterController"
import { RedDotController } from "./RedDotController"
import { OnHookController } from "../commonController/OnHookController"
import { MiniGameController } from "../commonController/MiniGameController"
import { FairyWishController } from "../commonController/FairyWishController"
import { SvipMainController } from "../commonController/SvipMainController"
import { EyouManager } from "../commonController/EyouManager"
import { FlowerRankControll } from "../commonController/FlowerRankControll"
import { TranslationManager } from "../commonController/TranslationManager"
import { HaloController } from "../commonController/HaloController"

// TypeScript file
export class ModulesController {
    public constructor() {
        ActivityForeshowManager.GetInstance()
        SceneController.GetInstance()
        FightController.GetInstance()
        new AutoFightController()
        SkillController.GetInstance()
        ViewManager.GetInstance()
        new GoodsController()
        new BagController()
        new TaskController()
        new StoryController()
        new GuildController()
        // // new StoryAnimationController()
        new CheatController()
        new EquipController()
        ItemUseController.GetInstance()
        new DialogueController()
        new DragonBallController()
        new GuardController()
        MainUIController.GetInstance()
        new CustomActivityController()
        new attributePotionController()
        new SevenDayController()
        new VipController()
        new RevelationController()
        new HolySealController()
        new OutWardController()
        new IllusionController()
        new PetEquipController()
        new RuneController()
        new DsgtController()
        new MedalController()
        new MonBookController()
        new ShopController
        new LungController()
        new ArmorController()
        new FashionController()
        new PartnerController()
        new PartnerAwakeController()
        new achvController()
        new GodBeastController()
        // new longlangController()
        new DressController()
        new UnrealController()
        new DemonController()
        new StarEquipController()
        new chcController()
        new GodBefallController()
        new MapController()
        new RedPacketController()
        new PushGiftController()
        new PkStatusController()
        new FriendController()
        new FirstRechargeController()
        new MarketController()
        new BaseDungeonController()
        new FirstBloodController()
        new GuildActivityController()
        new ChatController()
        new RuneTreasureController()
        new KaifuActivityController()
        new CompositeController()
        new MarriageController()
        new HolyTerritoryController()
        new BossController()
        new ReliveController()
        new GuildFightController()
        new TeamController()
        new BrightSeaController()
        new ArenaController()
        new KfHolyAreaController()
        new MondaysAwardController()
        new SuitActivityController()
        new BabyController()
        new RankController()
        new NineSkyController()
        new FunctionOpenController()
        new SnatchTreasureController()
        new WelfareController()
        new PrayController()
        new DungeonPartnerController()
        new DailyController()
        new DepositController()
        new HolyBattleController()
        new TopPkController()
        new kfSingleRankController()
        new ReincarnationController()
        new NoonPartyController()
        new BanquetController()
        new TempleAwakenController()
        new DiamondFightController()
        // new OutLineController()
        new FriendInviteController()
        new TopVipController()
        //new SurpriseGiftController()
        new SurpriseGiftController()
        new Kf1vnController()
        new AttentionController()
        new FestivalController()
        new EternityController()
        new FairyWishController()
        new LimitLevelShopController()
		new GodCourtController()
		new CompeteListController()
        new TSCrackController()
		new kfStageController()
		new SeaHegemonyController()
        new MaskController()
        new HotPointController()
        new longlangController()
        new DragonWhisperController()
        new ListDuobaoController()
        new GrowthBenefitsController()
        new AdventureController()
        new TreasureMapController()
        new SentientActController()
        new AddVipServiceController()
        new CycleimpActlistController()
        new WeekCardController()
        new AutoBrushController()
        new MonsterController()
        RedDotController.ins
        new OnHookController()
        new BannerController()
        new MainStrongerController()
        new GhostWalkController()
        new MiniGameController()
        new SvipMainController()
        new EyouManager()
        new FlowerRankControll()
	    new TranslationManager()
        new HaloController()
    }
    static _instance
    public static GetInstance() {
        if (!ModulesController._instance) {
            ModulesController._instance = new ModulesController()
        }
        return ModulesController._instance
    }
}

window["ModulesController"] = ModulesController