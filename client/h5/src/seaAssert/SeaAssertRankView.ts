import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import { SeaAssertRankItem } from "./SeaAssertRankItem"
import { SeaAssertRankTab } from "./SeaAssertRankTab"

export class SeaAssertRankView extends BaseView1 {
    InitEvent
    initItem
    initTab
    req_data

    public constructor() {
        super()

        this.base_file = "seaAssert"
        this.layout_file = "SeaAssertRankView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.click_bg_toClose = true
        this.use_background = true
        this.is_center = true
        this.back_login_toClose = true;
        let _model: SeaHegemonyModel = SeaHegemonyModel.GetInstance()
        let _tab_ac: LoopScrowViewMgr = null
        let _item_ac: LoopScrowViewMgr = null
        let select_tab = 0;

        let goods_model = GoodsModel.GetInstance()
        let reward_list = []
        this.load_callback = () => {
            this.InitEvent()
            this.initTab();
        }

        this.preload_server_config = {
            config_seacraft_daily_reward: false,
            config_sea_craft_daliy_rank1: false,
            config_sea_craft_daliy_rank2: false
        }
        this.InitEvent = () => {
            Util.AddClickEvent(
                this._img_close, () => {
                    this.Close()
                },
                this,
                true
            )
            this.BindEvent(
                _model,
                SeaHegemonyModel.ASSERT_RANK_DATA, () => {
                    this.initItem()
                }
            )

            this.BindEvent(
                _model,
                SeaHegemonyModel.ASSERT_RANK_TAB, (index: number) => {
                    select_tab = index;
                    this.initTab();
                    this.initItem();
                }
            )
        }

        this.close_callback = () => {
            if (_tab_ac) {
                _tab_ac.DeleteMe()
                _tab_ac = null
            }
            if (_item_ac) {
                _item_ac.DeleteMe()
                _item_ac = null
            }
            select_tab = 0;
            for (let key in reward_list) {

                // [ts2lua]reward_list下标访问可能不正确
                let item = reward_list[key]
                item.DeleteMe()
            }
            reward_list = []
        }

        this.initTab = () => {
            let tabList = [{ id: 0, name: "全部" }, { id: 1, name: "本域" }]
            if (!_tab_ac) {
                _tab_ac = new LoopScrowViewMgr()
                _tab_ac.SetData(this._Scroller1, SeaAssertRankTab, tabList, LoopScrCon.Horizontal)
            } else {
                _tab_ac.replaceAll(tabList)
            }
            _tab_ac.SetSelectIndex(select_tab);
            this.req_data();
        }

        this.initItem = () => {
            let list = []
            let rank_cfg = []
            if (select_tab == 0) {
                list = _model.assertRankData_all?.rank_list
                rank_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_craft_daliy_rank2", false)
            } else {
                list = _model.assertRankData?.rank_list
                rank_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_craft_daliy_rank1", false)
            }

            let data = list || []
            _model.SetAssertRankCfg(data, rank_cfg)
            if (data.length > 0) {
                if (!_item_ac) {
                    _item_ac = new LoopScrowViewMgr()
                    _item_ac.SetData(this._Scroller2, SeaAssertRankItem, data, LoopScrCon.Vertical)
                } else {
                    _item_ac.replaceAll(data)
                }
            }
            this.empty_gp.visible = data.length <= 0;
            this._Scroller2.visible = data.length > 0;
            // [ts2lua]lua中0和空字符串也是true，此处select_tab == 0需要确认
            let a_data = select_tab == 0 ? _model.assertRankData_all : _model.assertRankData
            if (a_data) {
                // [ts2lua]lua中0和空字符串也是true，此处a_data.my_rank == 0需要确认
                this._lb_rank.text = (a_data.my_rank == 0 && ("未上榜") || (a_data.my_rank))
                let pos_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seacraft_daily_reward", false)
                // [ts2lua]pos_cfg下标访问可能不正确
                this._lb_job.text = pos_cfg[a_data.my_pos].name
                let roleVo = RoleManager.GetInstance().GetMainRoleVo()
                let seaId: number = (a_data?.my_sea ? a_data.my_sea : a_data.sea_id) - 1;
                this._lb_name.text = _model.titleList[seaId] + "·" + roleVo.name
                this._lb_fight.text = WordManager.ConvertNum(a_data.my_power)
                this._lb_num.text = a_data.my_num
                this._lb_null.visible = a_data.my_rank == 0
                // this._gp_reward.visible = a_data.my_rank == 0
                if (a_data.my_rank > 0) {
                    let cfg = _model.AssertRankCfg(rank_cfg, a_data.my_rank)
                    if (cfg) {
                        let rewards = JSON.parse(cfg.reward)
                        let index = 0;

                        for (let _ in reward_list) {
                            var item = reward_list[_]
                            item.SetVisible(false)
                        }

                        for (let key in rewards) {
                            // [ts2lua]rewards下标访问可能不正确
                            let info = rewards[key]
                            // [ts2lua]reward_list下标访问可能不正确
                            let item = reward_list[index]
                            if (!item) {
                                item = new BaseAwardItem(this.Content)
                                item.Load()
                                item.SetScale(0.45)
                                table.insert(reward_list, item)
                            }
                            item.SetVisible(true);
                            let [type_id, lock] = goods_model.GetMappingTypeId(info[0], info[1])
                            let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
                            if (goods_vo) {
                                item.SetData(goods_vo.type_id, info[2], lock)
                            }
                            index = index + 1
                        }
                    }
                }
            }
        }

        this.req_data = () => {
            let sever_time = TimeUtil.getServerTimeMs()
            if (select_tab == 0 && (!_model.assertRankData_all || sever_time - _model.assertRankData_all.req_time >= 3000)) {
                _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18711)
                return true
            }
            else if (select_tab == 1 && (!_model.assertRankData || sever_time - _model.assertRankData.req_time >= 3000)) {
                _model.Fire(SeaHegemonyModel.REQUEST_PROTO, 18704, "c", _model.seaHegemonyData.camp)
                return true
            }
            return false
        }
    }

    public DeleteMe() {
        super.DeleteMe();
    }


    bg_img: Laya.Image
    img_title: Laya.Image
    lb_title: Laya.Label
    _img_close: Laya.Image
    bg: Laya.Image
    empty_gp: Laya.Box
    _Image10: Laya.Image
    _Label7: Laya.Label
    _Group1: Laya.Box
    _Image4: Laya.Image
    _Label1: Laya.Label
    _Image5: Laya.Image
    _Label2: Laya.Label
    _Image6: Laya.Image
    _Label3: Laya.Label
    _Image7: Laya.Image
    _Label4: Laya.Label
    _Image8: Laya.Image
    _Label5: Laya.Label
    _Image9: Laya.Image
    _Label6: Laya.Label
    _lb_rank: Laya.Label
    _lb_job: Laya.Label
    _lb_name: Laya.Label
    _lb_fight: Laya.Label
    _lb_num: Laya.Label
    _lb_null: Laya.Label
    _Scroller3: Laya.Panel
    Content: Laya.HBox
    _Scroller2: Laya.List
    _Scroller1: Laya.List
    public GetComponents() {
        [
            this.bg_img,
            this.img_title,
            this.lb_title,
            this._img_close,
            this.bg,
            this.empty_gp,
            this._Image10,
            this._Label7,
            this._Group1,
            this._Image4,
            this._Label1,
            this._Image5,
            this._Label2,
            this._Image6,
            this._Label3,
            this._Image7,
            this._Label4,
            this._Image8,
            this._Label5,
            this._Image9,
            this._Label6,
            this._lb_rank,
            this._lb_job,
            this._lb_name,
            this._lb_fight,
            this._lb_num,
            this._lb_null,
            this._Scroller3,
            this.Content,
            this._Scroller2,
            this._Scroller1,
        ]
            = this.GetChildrenByNames([

                "bg_img",
                "img_title",
                "lb_title",
                "_img_close",
                "bg",
                "empty_gp",
                "_Image10",
                "_Label7",
                "_Group1",
                "_Image4",
                "_Label1",
                "_Image5",
                "_Label2",
                "_Image6",
                "_Label3",
                "_Image7",
                "_Label4",
                "_Image8",
                "_Label5",
                "_Image9",
                "_Label6",
                "_lb_rank",
                "_lb_job",
                "_lb_name",
                "_lb_fight",
                "_lb_num",
                "_lb_null",
                "_Scroller3",
                "Content",
                "_Scroller2",
                "_Scroller1",
            ])
        this._Scroller3.hScrollBar.visible = false;
    }
}
window["SeaAssertRankView"] = SeaAssertRankView