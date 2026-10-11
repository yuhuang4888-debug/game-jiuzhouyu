import { ErlangParser } from "../util/ErlangParser";

/**
 * 特殊字符
 */
export const SpecialCharKey = {
    TimeUtil1: "//",
    Util1: /[`a-z0-9~!@#$%^&*()_\-+=<>?:"{}|,.\/;'\\[\]·~！@#￥%……&*（）——\-+={}|《》？：“”【】、；‘’，。、 ]/ig,
    UserMsgAdapter1: "//",
    MainUITaskItem1: /'/g,
    ColorUtil1: /'/g,
    PlatformManager1: "//",
    ShopBulkPurchaseView1: "'",
    ErlangParser1: "\"",
    HttpUtil1: "//",
    ShopItem1: "'",
    ShopMysteriouItem1: "'",
    attributePotionItem1: "'",
    IllusionTips1: "'",
    IllusionTips2: /"/g,
    LoginNoticeItem1: "'",
    RedPacketCtrlView1: "'",
    RuneMainUIView1: "'",
    RuneMainUIView2: /"/g,
    RuneSkillView1: "'",
    RuneSkillView2: /"/g,
    ShopLimitItem1: "'",
}