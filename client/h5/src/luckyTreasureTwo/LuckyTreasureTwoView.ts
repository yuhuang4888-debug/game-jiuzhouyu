import { Alert, Alert_Type } from '../alert/Alert';
import { BaseItem1 } from '../common/BaseItem1';
import { Enum_UILayer } from '../common/LayerManager';
import { OpenFun } from '../common/OpenFun';
import { ResManager } from '../common/ResManager';
import { RewardPreView } from '../common/RewardPreView';
import { table } from '../common/table';
import { UIEffect } from '../common/UIEffect';
import { CustomActivityDefine } from '../commonModel/CustomActivityDefine';
import { CustomActivityModel } from '../commonModel/CustomActivityModel';
import { GoodsModel } from '../commonModel/GoodsModel';
import { RoleManager } from '../commonModel/RoleManager';
import { RuneTreasureModel } from '../commonModel/RuneTreasureModel';
import { VipModel } from '../commonModel/VipModel';
import { ServerTimeModel } from '../serverTime/ServerTimeModel';
import { Message } from '../sysInfo/SysInfoController';
import { ColorUtil } from '../util/ColorUtil';
import { ErlangParser } from '../util/ErlangParser';
import { GameResPath } from '../util/GameResPath';
import { TimeUtil } from '../util/TimeUtil';
import { GlobalTimerQuest, GetSizeDeltaX, Util, SetSizeDeltaX, SetHtmlStyle, HtmlColorTxt, SetHtmlCenter } from '../util/Util';
import { LuckyTreasureTwoItem } from './LuckyTreasureTwoItem';
import { Config } from "../common/Config"
import { PlatformManager } from '../PlatformManager';

export class LuckyTreasureTwoView extends BaseItem1 {
    InitEvent;
    LocalDeleteMe;
    LoadSuccess;
    auto;
    item_list;
    mats;
    max_slider_value;
    reward_list;
    turn;
    base_type;
    record_item_;
    UpdateView;
    IsOver;
    UpdateItem;
    cur_tab;
    GoToRecharge
    CancelUpdate
    ChangeBtnDesc

    Float;
    Float2;
    OnTimer;
    CancelTimer;
    UpdateItemNums
    public static LUCK_STONE_ID = 36255102 //幸运石id

    public constructor(parent?) {
        super(parent);

        this.base_file = 'luckyTreasureTwo';
        this.layout_file = 'LuckyTreasureTwoView';
        this.layer_value = Enum_UILayer.UI;
        let model = CustomActivityModel.GetInstance();
        this.base_type = 102;
        this.item_list = [];
        this.reward_list = [];
        this.cur_tab = 1;
        let count_time_id_ = null;
        let coin_cost = 40 //用勾玉代替的价格

        //动画
        let base_y = 270;
        let shake_y = 8;
        let dur = 1000;
        let tween_update;
        let state = 1;

        let end_time, activity_jump_id, update_timer_id;
		let cus_model = CustomActivityModel.GetInstance()
        let local_CustomActivityDefine = CustomActivityDefine
        let key_str = Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.LUC_TREA_TWO+"@"+CustomActivityModel.GetInstance().lucky_sub_type

        this.preload_server_config = {
            config_treasure_hunt_guide: false
        };

        this.load_callback = () => {
            this.item_sc.hScrollBarSkin = '';
            this.LoadSuccess();
            this.InitEvent();
        };

        this.LocalDeleteMe = () => {
            Laya.Tween.clearAll(this._img_float1);
            if (tween_update) {
                tween_update.recover();
                tween_update = null;
            }

            if (this.item_list && this.item_list.length > 0) {
                for (let _tmpi in this.item_list) {
                    var obj = this.item_list[_tmpi];
                    obj.DeleteMe();
                }
                this.item_list = null;
            }
            if (this.record_item_) {
                this.record_item_.DeleteMe();
                this.record_item_ = null;
            }
            this.record_item_ = null;
            this.CancelUpdate()
            this.CancelTimer();
            //this.ClearUIEffect(this.effect_gp)
        };

        this.LoadSuccess = () => {
            this._lb_desc1.style.bold = true;
            this._lb_desc2.style.bold = true;
            if(PlatformManager.IsEyouPlatform()){
                this._lb_desc1.y= 799
                SetHtmlStyle(this._lb_desc1, { c: '#663915', f: 20, ww: true, w: 700 });
                SetHtmlStyle(this._lb_desc2, { c: '#663915', f: 20, ww: true, w: 700 });
            }else{
            SetHtmlStyle(this._lb_desc1, { c: '#663915', f: 20, ww: false, w: 720 });
            SetHtmlStyle(this._lb_desc2, { c: '#663915', f: 20, ww: false, w: 720 });
            }

            this._lb_desc1.innerHTML = `抽中普通奖励可获得${HtmlColorTxt('10点幸运值', "'#d85d03'")}，抽中大奖幸运值将清空每次鉴宝均`;
            this._lb_desc2.innerHTML = `有机会获得大奖，当幸运值满时下次鉴宝${HtmlColorTxt('必得大奖', "'#d85d03'")}`;
            if(PlatformManager.IsEyouPlatform()){
                SetHtmlCenter(this._lb_desc1, { x: 10, w: 700 });
                SetHtmlCenter(this._lb_desc2, { x: 10, w: 700 });
            }else{
            SetHtmlCenter(this._lb_desc1, { x: 0, w: 720 });
            SetHtmlCenter(this._lb_desc2, { x: 0, w: 720 });
            }

            if (!tween_update) {
                tween_update = Laya.Handler.create(
                    this,
                    (value?) => {
                        if (state == 2) {
                            this.Float();
                        } else {
                            this.Float2();
                        }
                    },
                    null,
                    false
                );
            }

            this._img_float1.y = base_y - shake_y;
            this.Float();
        };

        this.Float = () => {
            state = 1;
            Laya.Tween.clearAll(this._img_float1);
            Laya.Tween.to(this._img_float1, { y: base_y + shake_y }, dur, Laya.Ease.sineInOut, tween_update);
        };

        this.Float2 = () => {
            state = 2;
            Laya.Tween.clearAll(this._img_float1);
            Laya.Tween.to(this._img_float1, { y: base_y - shake_y }, dur, Laya.Ease.sineInOut, tween_update);
        };

        this.CancelUpdate = () => {
            if (count_time_id_) {
                GlobalTimerQuest.CancelQuest(count_time_id_);
                count_time_id_ = null;
            }
        }
        this.GoToRecharge = () => {
            Alert.Show('勾玉不足，是否前往充值?', Alert_Type.Two, () => {
                VipModel.GetInstance().Fire(VipModel.OPEN_VIEW, 'RechargeView');
            }, null, '充值', '取消');
        }
        this.ChangeBtnDesc=()=>{
            this.auto = false;
            this.Text1.text = '自动鉴宝';
        }
        this.InitEvent = () => {
            this.BindEvent(model, CustomActivityDefine.EVENT.UPDATE_VIEW, (base_type?, sub_type?) => {
                if (base_type == this.base_type && model.lucky_sub_type == sub_type) {
                    this.UpdateView();

                    if (this.record_item_) {
                        this.record_item_.ResetRecord(this.cur_tab);
                    }
                }
            });
            this.BindEvent(model, CustomActivityDefine.EVENT.STOP_AUTO, (base_type?, sub_type?) => {
                if (base_type == this.base_type && model.lucky_sub_type == sub_type) {
                    this.ChangeBtnDesc()
                    this.ClearUIEffect(this.effect_gp);
                }
            });
			//监听绑定事件
			this.BindEvent(cus_model, local_CustomActivityDefine.EVENT.UPDATE_TAB_RED, (key?, state?) => {
				if(key==key_str){
					this.UpdateItemNums()
				}
			})
            Util.AddClickEvent(
                this.go_btn,
                () => {
                    if (this.IsOver()) {
                        Message.show('本次活动已结束');
                        return;
                    }
                    let my_have_ = RoleManager.GetInstance().mainRoleInfo.jin;
                    let lucky_num_ = GoodsModel.GetInstance().GetTypeGoodsNum(CustomActivityModel.LUCK_STONE_ID);
                    if (lucky_num_ >= 1) {
                        model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33244, this.base_type, model.lucky_sub_type, 1, 0, this.turn);
                    } else {
                        let is_jump = model.getKeyDicValue(this.base_type, model.lucky_sub_type, 'is_jump_lucky');
                        if (is_jump) {
                            model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33244, this.base_type, model.lucky_sub_type, 1, 2, this.turn);
                        } else {
                            Alert.Show(`您的鉴宝石不足，继续鉴宝将消耗勾玉<br>（${coin_cost}勾玉/1次）`, Alert_Type.AlertTypeCheckBox,
                                () => {
                                    if (is_jump) {
                                        model.setKeyDicValue(this.base_type, model.lucky_sub_type, 'is_jump_lucky', true);
                                    }
                                    if (my_have_ < coin_cost) {
                                        this.GoToRecharge()
                                    }
                                    model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33244, this.base_type, model.lucky_sub_type, 1, 2, this.turn);
                                }, null, null, null, null, null,
                                () => {
                                    is_jump = !is_jump;
                                }
                            );
                        }
                    }
                },
                this,
                true
            );
            Util.AddClickEvent(
                this.auto_btn,
                () => {
                    this.CancelUpdate()
                    if (this.IsOver()) {
                        Message.show('本次活动已结束');
                        return;
                    }
                    if (!this.auto) {
                        let is_jump = model.getKeyDicValue(this.base_type, model.lucky_sub_type, 'is_jump_lucky_auto');

                        let auto_func = () => {
                            this.auto = true;
                            if (is_jump) {
                                model.setKeyDicValue(this.base_type, model.lucky_sub_type, 'is_jump_lucky_auto', true);
                            }
                            let my_have_ = RoleManager.GetInstance().mainRoleInfo.jin;
                            let lucky_num_ = GoodsModel.GetInstance().GetTypeGoodsNum(CustomActivityModel.LUCK_STONE_ID);
                            if (my_have_ >= coin_cost || lucky_num_ > 0) {
                                this.Text1.text = '停止鉴宝';

                                let OnTime = () => {
                                    let my_have = RoleManager.GetInstance().mainRoleInfo.jin;
                                    let lucky_num = GoodsModel.GetInstance().GetTypeGoodsNum(CustomActivityModel.LUCK_STONE_ID);

                                    //自动鉴定逻辑
                                    if (this.auto) {
                                        if (lucky_num > 0) {
                                            //鉴宝石
                                        model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33244, this.base_type, model.lucky_sub_type, 1, 1, this.turn);
                                    } else {
                                            //勾玉
                                            if (my_have >= coin_cost) {
                                                model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33244, this.base_type, model.lucky_sub_type, 1, 1, this.turn);
                                            } else {
                                                this.ChangeBtnDesc()
                                                this.CancelUpdate()
                                                this.GoToRecharge()
                                                //给鉴宝面板发送停止指令
                                                model.Fire(CustomActivityDefine.EVENT.STOP_AUTO,  this.base_type, model.lucky_sub_type)
                                        }
                                    }

                                    } else {
                                        this.CancelUpdate()
                                        this.ChangeBtnDesc()
                                    }
                                };
                                count_time_id_ = GlobalTimerQuest.AddPeriodQuest(OnTime, 0.5, -1);
                            } else {
                                this.GoToRecharge()
                            }
                        };
                        if (is_jump) {
                            auto_func();
                        } else {
                            Alert.Show(`自动鉴宝将会持续进行鉴宝直至成功鉴宝大奖。鉴宝石不足时，将会直接消耗勾玉（${coin_cost}勾玉/1次）`, Alert_Type.AlertTypeCheckBox, auto_func, null, null, null, null, null, () => {
                                is_jump = !is_jump;
                            });
                        }
                    } else {
                        this.ChangeBtnDesc();

                        this.CancelUpdate()
                    }
                },
                this,
                true
            );
            Util.AddClickEvent(
                this._btn_golb,
                () => {
                    this.cur_tab = 1;
                    ResManager.GetInstance().SetImageSprite(this, this._img_golb, 'common4', 'ui_btn_achv_highlight', true);
                    ResManager.GetInstance().SetImageSprite(this, this._img_self, 'common4', 'ui_btn_achv', true);
                    this._Label3.color = '#9b572f';
                    this._Label4.color = '#ffffff';
                    if (this.record_item_) {
                        this.record_item_.ResetRecord(1);
                    }
                },
                this,
                false
            );
            Util.AddClickEvent(this._btn_self,() => {
                    this.cur_tab = 2;
                    ResManager.GetInstance().SetImageSprite(this, this._img_golb, 'common4', 'ui_btn_achv', true);
                    ResManager.GetInstance().SetImageSprite(this, this._img_self, 'common4', 'ui_btn_achv_highlight', true);
                    this._Label3.color = '#ffffff';
                    this._Label4.color = '#9b572f';
                    if (this.record_item_) {
                        this.record_item_.ResetRecord(2);
                    }
                },this,false
            );
            Util.AddClickEvent(this.reward_btn,() => {
                    let view = new RewardPreView();
                    view.no_name = true;
                    view.Open(this.reward_list);
                }, this, true);

            Util.AddClickEvent(this.other_activity,() => {
                    OpenFun.OpenFunHandler(activity_jump_id);
                }, this,true);
            model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33243, this.base_type, model.lucky_sub_type);
        };

        this.UpdateView = () => {
            let act_data = model.GetActData(this.base_type, model.lucky_sub_type);
            if (!act_data) {
                return;
            }
            this.turn = act_data.turn;
            let reward_list = act_data.reward_list;
            let grade_list = act_data.grade_info;
            this.UpdateItem(reward_list, grade_list);
            let info = model.GetActInfo(this.base_type, model.lucky_sub_type);
            if (info) {
                let condition = ErlangParser.GetInstance().Parse(info.condition);
                let lucky_list = condition[1][1];
                let max = 0;
                let add_value = Number(condition[2][1]);

                let trun_v = null;
                for (let _ in lucky_list) {
                    var v = lucky_list[_];
                    if (Number(v[0]) == act_data.turn) {
                        //max = Number(v[1])
                        trun_v = v;
                    }
                }

                if (trun_v) {
                    max = Number(trun_v[1]);
                    let now_lucky = act_data.draw_time * add_value;
                    this.lucky_num_text.text = now_lucky + '/' + max;
                    this.lucky_num_img.width = (now_lucky / max) * 599;
                } else {
                    this.lucky_num_text.text = '0/0';
                    this.lucky_num_img.width = 0;
                }
            }

            this.UpdateItemNums()
            if (!this.record_item_) {
                this.record_item_ = model.LoadActRecord(this.record_gp, this.base_type, model.lucky_sub_type, 2, false, null, '#ffffff');
            }
            let open_day = ServerTimeModel.GetInstance().GetOpenServerDay();
            this.other_activity.visible = false;
            // 特惠夺宝写死天数对应子类型配置
            let subType = {
                6: 4,
                7: 5
            };
            if (open_day >= 6 && open_day <= 7) {
                let info = CustomActivityModel.GetInstance().GetActInfo(101, subType[open_day]);
                if (info) {
                    this.other_activity.visible = true;
                    end_time = info.etime;
                    this.activity_icon.skin = GameResPath.GetIcon('icon', '33115');
                    activity_jump_id = 230;
                    update_timer_id = GlobalTimerQuest.AddPeriodQuest(
                        () => {
                            this.OnTimer();
                        },
                        1,
                        -1
                    );
                    this.OnTimer();
                }
            }
        };
        this.UpdateItemNums=()=>{
            let my_have = GoodsModel.GetInstance().GetTypeGoodsNum(CustomActivityModel.LUCK_STONE_ID);
            this.have_num_text.text = my_have + '/1';
            this.red_dot.visible = my_have>=1
        }

        this.CancelTimer = () => {
            if (update_timer_id) {
                GlobalTimerQuest.CancelQuest(update_timer_id);
                update_timer_id = null;
            }
        };

        this.UpdateItem = (list?, grade_list?) => {
            this.reward_list = [];
            if (list && list.length > 0) {
                table.sort(list, (a?, b?) => {
                    return a.grade < b.grade;
                });
                let rare_list = [];
                for (let _ in list) {
                    var v = list[_];
                    let condition = ErlangParser.GetInstance().Parse(v.condition);
                    if (condition[1] && condition[1][0] == 'rare' && condition[1][1] == '1') {
                        v.is_grade = false;
                        for (let key in grade_list) {
                            var value = grade_list[key];
                            if (value.grade_id == v.grade) {
                                v.is_grade = true;
                                break;
                            }
                        }
                        table.insert(rare_list, v);
                    }
                    let reward = ErlangParser.GetInstance().Parse(v.reward);
                    table.insert(this.reward_list, reward[0]);
                }

                let index = 0;
                for (let _ in rare_list) {
                    var v = rare_list[_];
                    let item = (this.item_list[index] && this.item_list[index]) || new LuckyTreasureTwoItem(this.Content);
                    item.Setdata(v);
                    this.item_list[index] = item;
                    item.Load();
                    index = index + 1;
                }
            }
        };

        this.IsOver = () => {
            if (this.item_list && this.item_list.length > 0) {
                let act_data = model.GetActData(this.base_type, model.lucky_sub_type);
                if (!act_data) {
                    return false;
                }
                let grade_list = act_data.grade_info;
                if (grade_list && grade_list.length > 0) {
                    let is_over = (grade_list.length == this.item_list.length && true) || false;
                    return is_over;
                } else {
                    return false;
                }
            }
        };

        this.OnTimer = () => {
            let time = end_time - TimeUtil.getServerTime();
            if (!this._lb_time.destroyed) this._lb_time.text = TimeUtil.convertTimeColor(time);
        };
    }
    public DeleteMe() {
        this.LocalDeleteMe();
        super.DeleteMe();
    }
img_buttom_ng:Laya.Image
img_buttom_bg2:Laya.Image
img_buttom_bg3:Laya.Image
_lb_title:Laya.Label
_Image5:Laya.Image
_img_float1:Laya.Image
Image2:Laya.Image
lucky_num_img:Laya.Image
lucky_num_text:Laya.Label
_lb_xyz:Laya.Label
reward_btn:Laya.Image
_btn_golb:Laya.Box
_img_golb:Laya.Image
_Label3:Laya.Label
_btn_self:Laya.Box
_img_self:Laya.Image
_Label4:Laya.Label
item_sc:Laya.Panel
Content:Laya.HBox
_lb_desc1:Laya.HTMLDivElement
_lb_desc2:Laya.HTMLDivElement
auto_btn:Laya.Box
Image:Laya.Image
Text1:Laya.Label
go_btn:Laya.Box
Image111:Laya.Image
Text11:Laya.Label
Image11:Laya.Image
have_num_text:Laya.Label
red_dot:Laya.Image
record_gp:Laya.Box
effect_gp:Laya.Box
other_activity:Laya.Box
activity_icon:Laya.Image
_lb_time:Laya.Label
    public GetComponents() {
[
this.img_buttom_ng,
this.img_buttom_bg2,
this.img_buttom_bg3,
this._lb_title,
this._Image5,
this._img_float1,
this.Image2,
this.lucky_num_img,
this.lucky_num_text,
this._lb_xyz,
this.reward_btn,
this._btn_golb,
this._img_golb,
this._Label3,
this._btn_self,
this._img_self,
this._Label4,
this.item_sc,
this.Content,
this._lb_desc1,
this._lb_desc2,
this.auto_btn,
this.Image,
this.Text1,
this.go_btn,
this.Image111,
this.Text11,
this.Image11,
this.have_num_text,
this.red_dot,
this.record_gp,
this.effect_gp,
this.other_activity,
this.activity_icon,
this._lb_time,
]
 = this.GetChildrenByNames([
"img_buttom_ng",
"img_buttom_bg2",
"img_buttom_bg3",
"_lb_title",
"_Image5",
"_img_float1",
"Image2",
"lucky_num_img",
"lucky_num_text",
"_lb_xyz",
"reward_btn",
"_btn_golb",
"_img_golb",
"_Label3",
"_btn_self",
"_img_self",
"_Label4",
"item_sc",
"Content",
"_lb_desc1",
"_lb_desc2",
"auto_btn",
"Image",
"Text1",
"go_btn",
"Image111",
"Text11",
"Image11",
"have_num_text",
"red_dot",
"record_gp",
"effect_gp",
"other_activity",
"activity_icon",
"_lb_time",
])
    }
}
 window["LuckyTreasureTwoView"]= LuckyTreasureTwoView