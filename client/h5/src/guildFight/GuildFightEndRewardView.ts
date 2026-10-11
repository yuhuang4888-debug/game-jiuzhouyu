import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuildFightEvent, GuildFightModel } from "../commonModel/GuildFightModel"
import { RoleManager } from "../commonModel/RoleManager"
import { PlatformManager } from "../PlatformManager"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { Util, HtmlColorTxt, SetHtmlStyle } from "../util/Util"

export class GuildFightEndRewardView extends BaseView1 {


    LoadSuccess
    DesCall
    InitView
    InitEvent
    public constructor() {
        super()

        this.base_file = "guildFight"
        this.layout_file = "GuildFightEndRewardView"
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        this.destroy_imm = true
        let local_color = ColorUtil
        let local_util = Util
        let local_color_type = ColorType
        let local_word = WordManager
        let local_event = GuildFightEvent
        let gModel = GoodsModel.GetInstance()
        let roleMgr = RoleManager.GetInstance()
        let model = GuildFightModel.GetInstance()

        let wining_cfg_ = null
        let buff_cfg_ = null
        let item_list_ = []
        this.preload_server_config = { "config_terri_war_streak_reward": false, "config_terri_war_buff": false }
        this.load_callback = () => {
            this.buff_scroller.vScrollBarSkin=""
            this.reward_scroll.hScrollBarSkin=""
            SetHtmlStyle(this.buff_label,{c:"#19ae4a",f:20,w:576,lh:25})
            this.LoadSuccess()
        }

        this.destroy_callback = () => {
            this.DesCall()
        }

        this.LoadSuccess = () => {
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._Image5, GameResPath.GetIcon("guildFight", "uitc_031"), true)
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._Image7, GameResPath.GetIcon("guildFight", "uitc_031"), true)
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._Image9, GameResPath.GetIcon("guildFight", "uitc_030"))
            // ResManager.GetInstance().SetOutsideImageSprite(this, this._Image10, GameResPath.GetIcon("guildFight", "uitc_030"))
            wining_cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_terri_war_streak_reward", false)
            buff_cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_terri_war_buff", false)
            if (wining_cfg_ && buff_cfg_) {
                this.InitView()
                this.InitEvent()
            }
        }

        this.InitView = () => {
            // if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
            //     this.desc1.text =
            //         Util.StrToHTML(
            //             "Guild lain mendapatkan " + HtmlColorTxt("Buff Motivasi Moral ", local_color.GetColorDark(local_color_type.ORANGE)) + "saat mereka melawan Overlord Guild dgn " + HtmlColorTxt("jlh kemenangan beruntun>2", local_color.GetColorDark(local_color_type.ORANGE)) + "\n" + HtmlColorTxt("Semakin banyak kemenangan beruntun, semakin kuat efek Buff", local_color.GetColorDark(local_color_type.GREEN))
            //         )
            //     this.desc2.text =
            //         Util.StrToHTML(
            //             "Guild lain mengakhiri Overlord Guild dgn jlh" + HtmlColorTxt("Kemenangan beruntun>1.", local_color.GetColorDark(local_color_type.ORANGE)) + HtmlColorTxt("Semakin besar jlh kemenangan beruntun,", local_color.GetColorDark(local_color_type.GREEN)) + "semakin bagus hadiah pembunuhan Overlord Guild"
            //         )
            // } else {
            this.PreHtml()
            let color_orange="'#d15e00'"
            let desc1 = HtmlColorTxt("连胜次数>2", color_orange)
            let desc2 = HtmlColorTxt("士气鼓舞buff",  color_orange)
            let desc3 = HtmlColorTxt("连胜次数越多，buff效果越强", "'#e33a3a'")
            let desc_str1 = `其他结社与${desc1}的最强结社进行战斗时可以获得${desc2}<br>${desc3}`
            this.desc1.innerHTML =
                Util.StrToHTML(
                    desc_str1
                    
                )

            let desc4 = HtmlColorTxt("连胜次数>1", color_orange)
            let desc5 = HtmlColorTxt("连胜次数越多", color_orange)
            let desc6 = HtmlColorTxt("终结者：新一届的 最强结社", color_orange)
            let desc_str2 = `其他结社终结${desc4}的最强结社，${desc5}，终结最强结社获得的奖励越高（${desc6}）`
            this.desc2.innerHTML =
                Util.StrToHTML(
                    desc_str2
    
                )
            // }
            let win_data = model.GetWinData()
            let win_time = win_data.win_num
            let str = ""
            let is_show_buff = null
            let is_show_buff2=false
            for (let key in buff_cfg_) {

                // [ts2lua]buff_cfg_下标访问可能不正确
                // [ts2lua]buff_cfg_下标访问可能不正确
                if (buff_cfg_[key].win_num1 <= win_time && win_time <= buff_cfg_[key].win_num2) {
                    is_show_buff = true
                    // [ts2lua]buff_cfg_下标访问可能不正确
                    let buff_attr = JSON.parse(buff_cfg_[key].buff)
                    for (let _tmpi in buff_attr) {
                        var vo = buff_attr[_tmpi]
                        str = str + local_word.GetProperties(vo[0]) + (" + ") + local_word.ConvertToPercentValue(vo[0], vo[1]) + "<br>"
                    }
                    this.buff_label.innerHTML = str
                    this.buff_label.style.width=576
                    is_show_buff2=str.length>0
                    break
                }
            }


           this. _box_null1.visible=!is_show_buff2
           
            is_show_buff = false
            let word_lv = roleMgr.GetMainRoleVo().worldLv || 1
            if (win_data) {
                let showKey = win_data.win_num
                if (win_data.reward_type == 2 && !(win_data.reward_owner != 0)) {
                    showKey = win_data.reward_key
                }
                for (let index in wining_cfg_) {

                    if ((wining_cfg_[index].min_wlv <= word_lv && word_lv <= wining_cfg_[index].max_wlv) && wining_cfg_[index].streak_times == showKey) {
                        // [ts2lua]wining_cfg_下标访问可能不正确
                        let reward_list = JSON.parse(wining_cfg_[index].break_reward)
                        is_show_buff = true
                        let i = 0
                        do {
                            let item = item_list_[i]
                            if (!item) {
                                item = new BaseAwardItem(this.Content)
                                item.Load()
                                item.SetItemSize(85, 85)
                                item_list_[i] = item
                            }
                            item.SetVisible(true)
                            let type_id, lock 
                            [type_id, lock ]= gModel.GetMappingTypeId(reward_list[i][0], reward_list[i][1])
                            let goods_vo = gModel.GetGoodsBasicByTypeId(type_id)
                            if (goods_vo) {
                                item.SetData(goods_vo.type_id, reward_list[i][2], lock)
                            }
                            i = i + 1
                        } while ((i < reward_list.length))
                        let j = reward_list.length
                        do {
                            let item = item_list_[j]
                            if (item) {
                                item.SetVisible(false)
                            }
                            j = j + 1
                        } while ((j < item_list_.length))
                        break
                    }
                }

                if (!is_show_buff) {
                    let j = 0
                    do {
                        let item = item_list_[j]
                        if (item) {
                            item.SetVisible(false)
                        }
                        j = j + 1
                    } while ((j < item_list_.length))
                }
            }

            //this._box_null1.visible=!is_show_buff
            // if (!is_show_buff) {
            //     this.noend_label.visible = true
            //     this.noend_img.visible = true
            // } else {
            //     this.noend_label.visible = false
            //     this.noend_img.visible = false
            // }
            let roleVo = roleMgr.GetMainRoleVo()
            let is_show=true
            if ((((win_data && win_data.reward_type == 2) && !(win_data.reward_owner != 0)) && roleVo.guild_id == win_data.winner) && roleVo.position == 1) {
                this.rewardLb.text = "未分配终结奖励"
                this.distributionBtn.visible = true
                if (win_data.reward_owner > 0) {
                    this.labelDisplay.text = "已分配"
                    Util.SetImageGray(this._Image11, true)
                } else {
                    this.labelDisplay.text = "分配"
                    Util.SetImageGray(this._Image11, false)
                }
                is_show=false
            } else {
                this.rewardLb.text = "当前终结奖励"
                this.distributionBtn.visible = false
            }
            this._box_null2.visible=!is_show_buff&&is_show
        }

        this.InitEvent = () => {
            Util.AddClickEvent(
                this.closeBtn, () => {
                    this.Close()
                },
                this,
                true
            )
            Util.AddClickEvent(
                this.distributionBtn, () => {
                    model.Fire(local_event.GUILDFIGHT_OPEN_VIEW, "GuildFightDistributionView")
                },
                this,
                true
            )
            this.BindEvent(
                model,
                local_event.UPDATE_GUILD_FIGHT_VIEW, () => {
                    this.InitView()
                }
            )
        }

        this.DesCall = () => {
            for (let _tmpi in item_list_) {
                var item = item_list_[_tmpi]
                item.DeleteMe()
            }
            item_list_ = []
            wining_cfg_ = null
        }
    }



    PreHtml() {
        this.desc1.style.color = "#663915"
        this.desc1.style.fontSize = 20
        this.desc1.style.lineHeight=30
        this.desc1.width = 620

        this.desc2.style.color = "#663915"
        this.desc2.style.fontSize = 20
        this.desc2.style.lineHeight=30
        this.desc2.width = 620

        if(PlatformManager.IsEyouPlatform()){
            this.desc1.style.lineHeight=5
            this.desc2.style.lineHeight=5
            this.desc1.width = 600
            this.desc2.width = 600
            this.desc1.style.leading = 0.1
            this.desc2.style.leading = 0.1
        }
        
    }


    public DeleteMe() {

        super.DeleteMe()
    }


_Image1:Laya.Image
closeBtn:Laya.Image
_Image2:Laya.Image
_Group1:Laya.Box
_Image5:Laya.Image
title1:Laya.Label
_Group2:Laya.Box
_Image7:Laya.Image
title2:Laya.Label
desc1:Laya.HTMLDivElement
desc2:Laya.HTMLDivElement
_Image9:Laya.Image
_Image9_bg:Laya.Image
_Image10:Laya.Image
_Image10_bg:Laya.Image
distributionBtn:Laya.Box
_Image11:Laya.Image
labelDisplay:Laya.Label
_Label1:Laya.Label
buff_scroller:Laya.Panel
buff_label:Laya.HTMLDivElement
rewardLb:Laya.Label
reward_scroll:Laya.Panel
Content:Laya.HBox
_box_null1:Laya.Box
nobuff_img:Laya.Image
nobuff_label:Laya.Label
nobuff_label_2:Laya.Label
_box_null2:Laya.Box
nobuff_img2:Laya.Image
nobuff_label2:Laya.Label
nobuff_label_22:Laya.Label
_title_Image2:Laya.Image
_lb_win_name:Laya.Label
public GetComponents() {
[
this._Image1,
this.closeBtn,
this._Image2,
this._Group1,
this._Image5,
this.title1,
this._Group2,
this._Image7,
this.title2,
this.desc1,
this.desc2,
this._Image9,
this._Image9_bg,
this._Image10,
this._Image10_bg,
this.distributionBtn,
this._Image11,
this.labelDisplay,
this._Label1,
this.buff_scroller,
this.buff_label,
this.rewardLb,
this.reward_scroll,
this.Content,
this._box_null1,
this.nobuff_img,
this.nobuff_label,
this.nobuff_label_2,
this._box_null2,
this.nobuff_img2,
this.nobuff_label2,
this.nobuff_label_22,
this._title_Image2,
this._lb_win_name,
]
 = this.GetChildrenByNames([

"_Image1",
"closeBtn",
"_Image2",
"_Group1",
"_Image5",
"title1",
"_Group2",
"_Image7",
"title2",
"desc1",
"desc2",
"_Image9",
"_Image9_bg",
"_Image10",
"_Image10_bg",
"distributionBtn",
"_Image11",
"labelDisplay",
"_Label1",
"buff_scroller",
"buff_label",
"rewardLb",
"reward_scroll",
"Content",
"_box_null1",
"nobuff_img",
"nobuff_label",
"nobuff_label_2",
"_box_null2",
"nobuff_img2",
"nobuff_label2",
"nobuff_label_22",
"_title_Image2",
"_lb_win_name",
])
}
}
 window["GuildFightEndRewardView"]= GuildFightEndRewardView