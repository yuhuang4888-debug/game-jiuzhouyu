import { BaseItem1 } from '../common/BaseItem1';
import { Config } from '../common/Config';
import { DownDropBtn } from '../common/DownDropBtn';
import { EventName } from '../common/EventName';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { ResManager } from '../common/ResManager';
import { table } from '../common/table';
import { EquipModel } from '../commonModel/EquipModel';
import { GoodsModel } from '../commonModel/GoodsModel';
import { GuildModel, GuildEvent, GuildPermission } from '../commonModel/GuildModel';
import { RoleManager } from '../commonModel/RoleManager';
import { TaskModel } from '../commonModel/TaskModel';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { Util } from '../util/Util';
import { GuildDepotItem } from './GuildDepotItem';
import { GuildDepotRecordItem } from './GuildDepotRecordItem';

export class GuildDepotView extends BaseItem1 {
    stage_cfg = null;
    color_cfg = null;
    goods_cfg = null;
    _set_stage = -1;
    _set_color = -1;
    _set_carrer = false;
    UpdateTimer
    cacheDepotList: any[];
    color_btn: DownDropBtn;
    loop_mgr: LoopScrowViewMgr;
    loop_mgr1: LoopScrowViewMgr;
    model: GuildModel;
    stage_btn: DownDropBtn;
    _fixed_good_list: any[];
    resMgr: ResManager;
    roleMgr: RoleManager;
    equipModel: EquipModel;
    goodsModel: GoodsModel;

    public constructor(parent?) {
        super(parent);

        this.model = GuildModel.GetInstance();
        this._fixed_good_list = [];
        this.base_file = 'guild';
        this.layout_file = 'GuildDepotView';
        this.resMgr = ResManager.GetInstance();
        this.roleMgr = RoleManager.GetInstance();
        this.equipModel = EquipModel.GetInstance();
        this.goodsModel = GoodsModel.GetInstance();
        this.preload_client_config = {
            ConfigGuild: false
        };
        this.load_callback = () => {
            this.LoadSuccess();
            this.ShowTaskDonateArrow()
        };
    }


    /**捐赠支线引导 */
    private ShowTaskDonateArrow() {
        if(!this.task_model.IsHasBranchTask(TaskModel.GuildDonateTaskId))return
        if (!this.story_model.task_supplement_list["GuildDonateTaskId"]) return
        if (!this.task_model.IsAllStepFinish(TaskModel.GuildDonateTaskId)) {
            let step = this.task_model.GetBranchTaskCfg(TaskModel.GuildDonateTaskId, 2)
            if (step) {
                GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._btn_donate, "Main", null, null, null, null, step, true)
            }
        }
    }

    public DeleteMe() {
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }
        if (this.loop_mgr1) {
            this.loop_mgr1.DeleteMe();
            this.loop_mgr1 = null;
        }
        if (this.stage_btn) {
            this.stage_btn.DeleteMe();
            this.stage_btn = null;
        }
        if (this.color_btn) {
            this.color_btn.DeleteMe();
            this.color_btn = null;
        }
        if (this.UpdateTimer) {
            clearTimeout(this.UpdateTimer);
            this.UpdateTimer = null;
        }
        super.DeleteMe();
    }

    LoadSuccess() {
        let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, 'ConfigGuild', true);

        this._list_item.vScrollBarSkin = '';
        this._list_msg.vScrollBarSkin = '';

        this.stage_cfg = cfg.down_drop_depot_stage;
        this.color_cfg = cfg.down_drop_depot_color;
        this.goods_cfg = cfg.depot_goods;

        //local_ResManager.SetOutsideImageSprite(this, this.Image3, GameResPath.GetIcon("guild", "uifh_026cjghhuizhang.png"), true)
        //local_ResManager.SetOutsideImageSprite(this, this._Image3, GameResPath.GetIcon("guild", "uifh_026cjghexds"))

        this.InitEvent();
        this.FireEvent();
        this.InitView();
        this.UpdateView();
    }

    FireEvent() {
        this.model.Fire(GuildEvent.REQUEST_PROTO, 40101);
    }

    InitEvent() {
        Util.AddClickEvent(
            this._btn_destroy,
            () => {
                this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildCleanView');
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_donate,
            () => {
                GlobalEventSystem.Fire(EventName.HIDE_FINGER, this._btn_donate)
                this.model.Fire(GuildEvent.OPEN_VIEW, 'GuildDepotSelectView');
            },
            this,
            true
        );
        this.BindVar(this.model, 'depot_info', () => {
            this.UpdateView();
        });
        this.BindVar(this.model, 'depot_score', () => {
            this._lb_point.text = `${this.model.GetDepotScore() || 0}`;
        });

        Util.AddClickEvent(
            this.GameObject,
            () => {
                this._set_carrer = !this._set_carrer;
                if (this._set_carrer) {
                    ResManager.GetInstance().SetImageSprite(this, this.image, 'common_asset', 'com_ui_gx1');
                } else {
                    ResManager.GetInstance().SetImageSprite(this, this.image, 'common_asset', 'com_ui_gx');
                }
                this.UpdateDepotItemsWithConditon(true);
            },
            this
        );
    }

    UpdateView() {
        let depot_info = this.model.GetDepotInfo();
        if (!depot_info) {
            return;
        }
        this._lb_point.text = `${depot_info.depot_score || 0}`;
        this.UpdateRecordItems(depot_info.exchange_records);
        this.UpdateDepotItemsWithConditon(false);
    }

    InitView() {
        this._btn_destroy.visible = this.model.HasPermission(GuildPermission.WAREHOUSE_MANAGER);
        let list = [];
        for (let _ in this.stage_cfg) {
            var vo = this.stage_cfg[_];
            table.insert(list, vo);
        }
        table.sort(list, (a?, b?) => {
            return a.cond < b.cond;
        });
        this.stage_btn = new DownDropBtn(this._dd_stage);
        this.stage_btn.Init(list, this.ClickBtnStage.bind(this), '品阶选择', 'content', this.layer_value, 5);
        this.stage_btn.Load();

        let color_list = [];
        for (let _ in this.color_cfg) {
            var vo = this.color_cfg[_];
            table.insert(color_list, vo);
        }
        table.sort(color_list, (a?, b?) => {
            return a.cond < b.cond;
        });
        this.color_btn = new DownDropBtn(this._dd_color);
        this.color_btn.Init(color_list, this.ClickBtnColor.bind(this), '品质选择', 'content', this.layer_value, 5);
        this.color_btn.Load();

        //this._ac_depot = eui. new ArrayCollection()
        //this._group_depot.dataProvider = this._ac_depot
        //this._group_depot.itemRenderer = GuildDepotItem

        this.loop_mgr1 = new LoopScrowViewMgr();
        this.loop_mgr1.SetData(this._list_msg, GuildDepotRecordItem, {}, LoopScrCon.Vertical);

        //this._ac_record = eui. new ArrayCollection()
        //this._group_record.dataProvider = this._ac_record
        //this._group_record.itemRenderer = GuildDepotRecordItem

        this.InitDepotGoodItems();
    }

    ClickBtnStage(index?, data?) {
        this._set_stage = data.cond;
        this.UpdateDepotItemsWithConditon(true);
    }

    ClickBtnColor(index?, data?) {
        this._set_color = data.cond;
        this.UpdateDepotItemsWithConditon(true);
    }

    UpdateDepotItems(list?: IGuildDepoGoods[], updateNow?, forceReset?) {
        if (!updateNow) {
            clearTimeout(this.UpdateTimer);
            this.cacheDepotList = list;
            this.UpdateTimer = setTimeout(() => {
                this.UpdateDepotItems(this.cacheDepotList, true, forceReset);
            }, 0.2);
            return;
        }
        let equip_attr_cfg = this.resMgr.GetGameConfigFromCache(this, 'Equipattr', false);
        let role_sex = RoleManager.GetInstance().GetMainRoleSex();
        list.sort((v2, v1) => {

            let value_v2 = v2.goods_id==1?999:1
            let value_v1 = v1.goods_id==1?999:1

            if (value_v2 != value_v1) {
                return value_v1 -value_v2;
            }else if (v1.color != v2.color) {
                return v1.color - v2.color;
            } else if (v1.stage != v2.stage) {
                return v1.stage - v2.stage;
            } else if (v1.star != v2.star) {
                return v1.star - v2.star;
            } else if (v1.sex != v2.sex) {
                if (v1.sex == 0) {
                    return -1;
                } else if (v2.sex == 0) {
                    return 1;
                }
                return v1.sex != role_sex ? -1 : 1;
            } else if (v1.equip_type != v2.equip_type) {
                return v2.equip_type - v1.equip_type;
            }
        });

        let goods_list = [];

        for (let _tmpi in this._fixed_good_list) {
            var info = this._fixed_good_list[_tmpi];
            info.is_item = true;
            table.insert(goods_list, info);
        }

        for (let _ in list) {
            var value = list[_];
            value.is_item = true;
            table.insert(goods_list, value);
        }

        //goods_list = table.merge(goods_list, list)

        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(this._list_item, GuildDepotItem, goods_list, LoopScrCon.Vertical);
        } else {
            this.loop_mgr.replaceAll(goods_list);
        }
    }

    UpdateRecordItems(list?) {
        this.loop_mgr1.replaceAll(list);
        //this._ac_record.source = list
    }
    //forceReset 设置位置到初始
    UpdateDepotItemsWithConditon(forceReset?) {
        let depot_info = this.model.GetDepotInfo();
        if (!depot_info) {
            return;
        }
        if (this._set_carrer == false && this._set_color == -1 && this._set_stage == -1) {
            this.UpdateDepotItems(depot_info.depot_goods, null, forceReset);
        } else {
            let list = [];
            let career = this.roleMgr.GetMainRoleVo().career;
            let sex = this.roleMgr.GetMainRoleVo().sex;
            for (let _tmpi in depot_info.depot_goods) {
                var info = depot_info.depot_goods[_tmpi];
                let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods.name, info.type_id, false);
                if (this._set_color != -1 && this._set_color != cfg.color) {
                } else {
                    let equip_attr_cfg = this.resMgr.GetGameConfigFromCache(this, 'Equipattr', false);
                    if (this._set_stage != -1 && this._set_stage != this.equipModel.GetStageByTypeId(info.type_id, equip_attr_cfg)) {
                    } else {
                        //需求说只过滤职业
                        if (!this._set_carrer || cfg.career_id == career || (cfg.career_id == 0 && (cfg.sex == 0 || cfg.sex == sex))) {
                            table.insert(list, info);
                        }

                        // if ((_set_carrer && cfg.career_id != 0) && career != cfg.career_id) {
                        // } else {
                        // 	if ((_set_carrer && cfg.sex != 0) && sex != cfg.sex) {
                        // 	} else {
                        // 		table.insert(list, info)
                        // 	}
                        // }
                    }
                }
            }
            this.UpdateDepotItems(list, null, forceReset);
        }
    }

    InitDepotGoodItems() {
        this._fixed_good_list = this.GetGoodDatas();
    }

    GetGoodDatas() {
        let list = [];
        for (let _tmpi in this.goods_cfg) {
            var cfg = this.goods_cfg[_tmpi];
            let info = Util.DeepCopy(cfg);
            this.goodsModel.SetBaseInfo(info);
            info.is_depot_fixed = true;
            table.insert(list, info);
        }
        return list;
    }

    _Image11: Laya.Image;
    _img_bg: Laya.Image;
    _Image2: Laya.Image;
    Image3: Laya.Image;
    _list_item: Laya.List;
    _Image3: Laya.Image;
    _list_msg: Laya.List;
    _Label1: Laya.Label;
    _lb_point: Laya.Label;
    _btn_destroy: Laya.Box;
    _Image1: Laya.Image;
    labelDisplay: Laya.Label;
    _btn_donate: Laya.Box;
    _Image111: Laya.Image;
    labelDisplay1: Laya.Label;
    _dd_stage: Laya.Box;
    _dd_color: Laya.Box;
    GameObject: Laya.Box;
    image: Laya.Image;
    text: Laya.Label;
    public GetComponents() {
        [this._Image11, this._img_bg, this._Image2, this.Image3, this._list_item, this._Image3, this._list_msg, this._Label1, this._lb_point, this._btn_destroy, this._Image1, this.labelDisplay, this._btn_donate, this._Image111, this.labelDisplay1, this._dd_stage, this._dd_color, this.GameObject, this.image, this.text] = this.GetChildrenByNames(['_Image11', '_img_bg', '_Image2', 'Image3', '_list_item', '_Image3', '_list_msg', '_Label1', '_lb_point', '_btn_destroy', '_Image1', 'labelDisplay', '_btn_donate', '_Image111', 'labelDisplay1', '_dd_stage', '_dd_color', 'GameObject', 'image', 'text']);
    }
}

window['GuildDepotView'] = GuildDepotView;
