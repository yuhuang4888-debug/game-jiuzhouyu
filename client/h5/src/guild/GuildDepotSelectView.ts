import { BaseView1 } from '../common/BaseView1';
import { EventName } from '../common/EventName';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { ResManager } from '../common/ResManager';
import { EquipModel } from '../commonModel/EquipModel';
import { GoodsModel } from '../commonModel/GoodsModel';
import { GuildModel, GuildDefine, GuildEvent } from '../commonModel/GuildModel';
import { RoleManager } from '../commonModel/RoleManager';
import { StoryModel } from '../commonModel/StoryModel';
import { TaskModel, TaskTipType } from '../commonModel/TaskModel';
import { Message } from '../sysInfo/SysInfoController';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { Util } from '../util/Util';
import { GuildDepotItem } from './GuildDepotItem';

export class GuildDepotSelectView extends BaseView1 {
    use_background = true;
    click_bg_toClose = true;
    is_center = true;
    destroy_imm = true;
    show_open_movie = true;
    loop_mgr: LoopScrowViewMgr;
    model: GuildModel;
    resMgr: ResManager;
    goodsModel: GoodsModel;
    preload_server_config = {
        config_guild_depot_score: false,
        config_equip_attr: false
    };
    config_guild_depot_score;
    config_equip_attr;
    total_score = 0;
    is_clicking = false

    public constructor() {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildDepotSelectView';
        this.layer_value = Enum_UILayer.Activity;
        //this.preload_server_config = [Goods=false, Equipattr=false, Guilddepotscore=false]

        this.load_callback = () => {
            this.LoadSuccess();
        };

        this.open_callback = () => { };

        this.destroy_callback = () => {
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe();
                this.loop_mgr = null;
            }
            this.total_score = 0;
            this.model.donateSelectDict = {};
        };

        this.model = GuildModel.GetInstance();
        this.resMgr = ResManager.GetInstance();
        this.goodsModel = GoodsModel.GetInstance();
    }


    /**捐赠支线引导 */
    private ShowTaskDonateArrow() {
        if (!this.task_model.IsHasBranchTask(TaskModel.GuildDonateTaskId)) {
            return
        }

        if (!this.story_model.task_supplement_list["GuildDonateTaskId"]
            || this.story_model.task_supplement_list["GuildDonateTaskId"] < 4) return

        if (!this.task_model.IsAllStepFinish(TaskModel.GuildDonateTaskId)) {
            let step = this.task_model.GetBranchTaskCfg(TaskModel.GuildDonateTaskId, 4)
            if (step) {
                GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.btnDonate, "Main", null, null, null, null, step, true)
            }
        }
    }

    public DeleteMe() {
        super.DeleteMe();
    }


    LoadSuccess() {
        this.equipScore.style.color = '#663915';
        this.equipScore.style.fontSize = 22;
        this.equipScore.style.wordWrap = false;
        this.config_guild_depot_score = ResManager.GetInstance().GetGameConfigFromCache(this, 'config_guild_depot_score', false);
        this.config_equip_attr = ResManager.GetInstance().GetGameConfigFromCache(this, 'config_equip_attr', false);
        let list = this.model.GetShowEquips();



        list = this.SortFunc(list)
        this.loop_mgr = new LoopScrowViewMgr();
        this.loop_mgr.SetData(this._list, GuildDepotItem, list, LoopScrCon.Vertical);

        this.InitEvent();
        this.UpdateView();
    }

    InitEvent() {
        Util.AddClickEvent(this._btn_close, this.Close.bind(this), this, true);
        Util.AddClickEvent(this.btnDonate, this.OnDonateBtnClick.bind(this), this, true);

        this.BindEvent(GoodsModel.GetInstance(), GoodsModel.CHANGE_BAG_LIST, (goods_list) => {
            if (!this.use_delete_method) {

                //检查是否是捐献装备的变化
                let is_update: boolean = false
                for (let i = 0; i < goods_list.length; i++) {


                    let goods_vo = goods_list[i]

                    if (this.model.donateSelectDict[goods_vo.goods_id]) {
                        is_update = true
                        break
                    }
                    // let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_vo.type_id)
                    // if (!basic) continue
                    // is_update = basic.type == 10
                }

                if (is_update) {
                    this.is_clicking=false
                    this.model.donateSelectDict={}
                    this.UpdateView()
                }
            }
        }
        )


        // this.BindVar(this.model, 'depot_score', this.UpdateView.bind(this));
        this.BindEvent(this.model, GuildEvent.SELECT_DONATE_EQUIP, (data: IGuildDepoGoods) => {
            let cfg = this.model.GetDepotScoreCfgByTypeID(data.type_id, this.config_equip_attr, this.config_guild_depot_score);
            let score = cfg.score_cost;
            if (!this.model.donateSelectDict[data.goods_id]) {
                this.model.donateSelectDict[data.goods_id] = { goods_id: data.goods_id, num: 1 };
                this.total_score += score;
            } else {
                delete this.model.donateSelectDict[data.goods_id]
                this.total_score -= score;
            }
            this.equipScore.innerHTML = `选中装备积分: <font color="#0a953e">${this.total_score}</font>`;
        });


        this.BindEvent(this.model, GuildEvent.REQUEST_40100, (err_code) => {
            if(err_code==4010001||err_code==4010000||err_code==4010002){
                this.is_clicking=false
                this.model.donateSelectDict={}
                this.UpdateView()
            }
        });


        this.BindEvent(this.story_model, StoryModel.EventName.UPDATE_TASK_STEP, () => {
            this.UpdateTaskStep()
        })

    }


    private UpdateTaskStep() {
        let step = this.story_model.GetTaskStep("GuildDonateTaskId")
        if (step >= 4) {
            this.story_model.UpdateTaskStep(TaskTipType.MountLevel, 1)
        }
        this.ShowTaskDonateArrow()
    }

    UpdateView() {
        this.total_score = 0;
        this.equipScore.innerHTML = `选中装备积分: <font color="#0a953e">${this.total_score}</font>`;
        let list = this.model.GetShowEquips();
        list = this.SortFunc(list)
        if (this.loop_mgr) {
            this.loop_mgr.replaceAll(list);
        }
    }

    private SortFunc(list) {
        let role_sex = RoleManager.GetInstance().GetMainRoleSex();
        list.sort((v1, v2) => {

            let v11 = v1.sex == 0 ? 1 : (v1.sex == role_sex ? 1 : 0)
            let v22 = v2.sex == 0 ? 1 : (v2.sex == role_sex ? 1 : 0)
            if (v11 != v22) {
                return v11 - v22
            } else if (v1.star != v2.star) {

                return v1.star - v2.star;
            }
            else if (v1.stage != v2.stage) {
                return v1.stage - v2.stage;
            } else if (v1.color != v2.color) {
                return v1.color - v2.color;
            } else if (v1.equip_type != v2.equip_type) {
                return v2.equip_type - v1.equip_type;
            }
        });
        return list
    }


    OnDonateBtnClick() {
        // if (this.model.CheckDepotOver()) {
        //     Message.show('仓库已满，无法继续捐献');
        //     return;
        // }

        if (this.is_clicking) {
            return Message.show('正在捐献中');
        }

        let donate_list = Object.values(this.model.donateSelectDict).filter((item) => !!item);
        if (!donate_list?.length) {
            return Message.show('请先选中装备再进行捐献~');
        }

        if (this.story_model.task_supplement_list["GuildDonateTaskId"]) {
            delete this.story_model.task_supplement_list["GuildDonateTaskId"]
            GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.btnDonate)
        }

        this.is_clicking = true
        this.model.Fire(GuildEvent.REQUEST_40102, donate_list);

        // this.model.donateSelectDict = {};
    }
    _btn_close: Laya.Image;
    btnDonate: Laya.Image;
    equipScore: Laya.HTMLDivElement;
    _list: Laya.List;
    public GetComponents() {
        [this._btn_close, this.btnDonate, this.equipScore, this._list] = this.GetChildrenByNames(['_btn_close', 'btnDonate', 'equipScore', '_list']);
    }
}
window['GuildDepotSelectView'] = GuildDepotSelectView;
