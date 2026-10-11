
import { EventName } from '../common/EventName';
import { Enum_UILayer } from '../common/LayerManager';
import { ResManager } from '../common/ResManager';
import { table } from '../common/table';
import { CustomActivityModel } from '../commonModel/CustomActivityModel';
import { ISConfSoap, ISConfSoapDebris, MonsterModel, MonsterModelEvent } from '../commonModel/MonsterModel';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { Util } from '../util/Util';
import { BaseItem1 } from './../common/BaseItem1';
import { MonsterIconItem } from './MonsterIconItem';
import { MonsterPropertyView } from './MonsterPropertyView';
import { GameResPath } from './../util/GameResPath';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { MonsterPropertyItemOne } from './MonsterPropertyItemOne';
import { ErlangParser } from './../util/ErlangParser';
import { BaseAwardItem } from '../common/BaseAwardItem';
import { GoodsModel } from '../commonModel/GoodsModel';
import { EnumMonsterProtocol } from '../commonController/MonsterController';
import { FightingShowSmallItem } from '../common/FightingShowSmallItem';
import { AutoBrushBaseView, EnumAutoBrushTabType } from '../autoBrush/AutoBrushBaseView';
import { AutoBrushModel } from '../commonModel/AutoBrushModel';
import { OutWardBaseModel } from '../commonModel/OutWardBaseModel';
import { UI_MODEL_TYPE } from '../common/UIModelClass3D';
import { StoryModel } from '../commonModel/StoryModel';
import { TaskTipType } from '../commonModel/TaskModel';
import { BaseWindowComponent } from '../common/BaseWindowComponent';

export class MonsterMainView extends BaseItem1 {
    public static readonly _layout_file: string = 'MonsterMainView';

    private loop_mgr: LoopScrowViewMgr;
    private loop_mgr1: LoopScrowViewMgr;
    private fightNum: FightingShowSmallItem;

    private item2: BaseAwardItem;
    private item1: MonsterIconItem[] = [];
    /**当前古宝id */
    private curSoapId: number = 0;
    /**当前古宝索引 */
    private curSoapIndex: number = 0;
    /**当前碎片id */
    private curDebrisId: number = 0;
    /**当前碎片选中索引 */
    private curDebrisIndex: number = -1;
    /**可展示古宝id */
    private soaps: number[] = [];
    /**可展示碎片id */
    private debrisIds: number[] = [];
    /**初始Y */
    private initY: number = 0;
    /**隐藏Y */
    private hideY: number = 0;
    /**模型id */
    private modeId: string;

    private get monsterModel() {
        return MonsterModel.GetInstance();
    }

    public constructor(parent?: any) {
        super(parent);

        this.base_file = 'monster';
        this.layout_file = 'MonsterMainView';
        this.layer_value = Enum_UILayer.Activity;

        this.load_callback = () => {
            // AutoBrushModel.GetInstance().CreatArrow(this, this.mosaicBox, 4);
            if (this.item2) {
                this.item2.DeleteMe();
                this.item2 = null;
            }
            this.LoadSuccess();
            this.InitEvent();
            let step = AutoBrushModel.GetInstance().GetStep()
            if ( step == 3 || step == 4) {
                // if (step == 2) {
                //     AutoBrushModel.GetInstance().SetStep(3)
                //     step = 3
                // }
                AutoBrushModel.GetInstance().CreatArrow(this, this.mosaicBox, step + 1)
            }
            // if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.ActiveSoap)
            //     && !this.task_model.IsCurrMainTaskHasFinish()) {
            //     if (this.story_model.GetTaskStep(TaskTipType.ActiveSoap) == 4) {
            //         this.story_model.UpdateTaskStep(TaskTipType.ActiveSoap, 5)
            //     }
            //     if (this.story_model.GetTaskStep(TaskTipType.ActiveSoap) == 2) {
            //         this.story_model.UpdateTaskStep(TaskTipType.ActiveSoap, 3)
            //     }
            // }
        };
    }

    private LoadSuccess() {
        this.fightNum = new FightingShowSmallItem(this.combatBox)
        this.fightNum.Load();
        this.fightNum.Updatefighting(this.monsterModel.combat);
        this.initY = this.fragmentsBox.y;
        this.hideY = this.fragmentsBox.y + this.fragmentsBox.height;
        this.fragmentsBox.y = this.hideY;
        this.fragmentsBox.alpha = 0;

        this.costHtml.width = 100
        this.costHtml.style.fontSize = 20
        this.costHtml.style.color = "#ffffff"
        this.costHtml.style.stroke = 1
        this.costHtml.style.strokeColor = "#000000"

        ResManager.GetInstance().SetTexture(
            this,
            this.imgBg1,
            GameResPath.GetIconOtherPath('monster', 'ui_zy_05')
        );
        ResManager.GetInstance().SetTexture(
            this,
            this.imgBg2,
            GameResPath.GetIconOtherPath('monster', 'ui_zy_11')
        );
        ResManager.GetInstance().SetTexture(
            this,
            this.imgBg3,
            GameResPath.GetIconOtherPath('monster', 'ui_zy_11')
        );
        ResManager.GetInstance().SetTexture(
            this,
            this.lineImg,
            GameResPath.GetIconOtherPath('common2', 'com_line_91')
        );


        this.RenderView();
    }


    public InitEvent() {
        // 点击查看属性
        Util.AddClickEvent(this.attrImg, () => {
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, MonsterPropertyView._layout_file);
        }, this, true);

        // 点击查看下一个古宝
        Util.AddClickEvent(this.rImg, () => {
            this.ClickRight();
        }, this, true);

        // 点击查看上一个古宝
        Util.AddClickEvent(this.lImg, () => {
            this.ClickLeft();
        }, this, true);

        // 前往
        Util.AddClickEvent(this.jumpBox, () => {
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, AutoBrushBaseView._layout_file, EnumAutoBrushTabType.eAutoBrush)
        }, this, true);

        // 前往
        Util.AddClickEvent(this.jump1Box, () => {
            GlobalEventSystem.Fire(EventName.OPEN_VIEW, AutoBrushBaseView._layout_file, EnumAutoBrushTabType.eAutoBrush)
        }, this, true);

        // 返回
        Util.AddClickEvent(this.returnImg, () => {
            this.ShowOrHideDebrisBox(false);
        }, this, true);

        // 点击激活
        Util.AddClickEvent(this.mosaicBox, () => {
            GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.mosaicBox)
            AutoBrushModel.GetInstance().CreatArrow(this, this.mosaicBox, 5)
            this.monsterModel.Fire(
                MonsterModelEvent.REQUEST_PROTO,
                EnumMonsterProtocol.eProtocol13321, 'hh', this.curSoapId, this.curDebrisId);
        }, this, true);


        // 选择icon回调
        this.BindEvent(this.monsterModel, MonsterModelEvent.TAB_SELECT, (debrisId: number, index: number) => {
            this.curDebrisId = debrisId;
            this.curDebrisIndex = index;
            this.RednerDebris();
            this.SelectIcon(index);
        });

        // 激活回调
        this.BindEvent(this.monsterModel, MonsterModelEvent.ACTIVALTION, () => {
            this.fightNum.Updatefighting(this.monsterModel.combat);
            if (this.monsterModel.GetActBySoapId(this.curSoapId)) {
                let confSoap: ISConfSoap = this.monsterModel.GetSoapConfBySoapId(this.curSoapId);
                let confSoapDebris: ISConfSoapDebris = this.monsterModel.GetSoapConfBySoapIdAndDebrisId(this.curSoapId, 1)
                let model_id = ErlangParser.GetInstance().parse(confSoapDebris.model_id);
                let data = {
                    _type: UI_MODEL_TYPE.GUBAO,
                    id: model_id[1],
                    name: confSoap.soap_name,
                    isFirst: true
                }
                OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data, UI_MODEL_TYPE.GUBAO)
                //结束指引
                if (this.task_model.IsSpecialBrushTask()) {
                    this.story_model.curr_view_story_step = 4
                    GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.mosaicBox)
                    GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return)
                }
                this.RenderView();
            } else {
                //继续指引
                if (this.task_model.IsSpecialBrushTask() && !this.task_model.IsCurrMainTaskHasFinish()) {
                    this.story_model.curr_view_story_step = 3
                    GlobalEventSystem.Fire(EventName.HIDE_FINGER, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return)
                    GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.mosaicBox)
                }
                this.SelectSoap(this.curSoapId);
            }
        });

        // 页签切换
        this.BindEvent(GlobalEventSystem, EventName.CHANGE_SUB_VIEW, (view_name: string) => {
            if (view_name == this.layout_file) {
                this.RenderView();
            }
        })

    }

    public createChildren() {
        if (this["GetComponents"]) {
            this["GetComponents"]()
            this.is_get = true
        }
        this.story_obj_list = this.story_obj_list || {}
        if (this.task_model.IsSpecialBrushTask()) {
            if (AutoBrushModel.GetInstance().IsGetSpeTaskItem(AutoBrushModel.Task_Item_ID_1)
                && AutoBrushModel.GetInstance().IsGetSpeTaskItem(AutoBrushModel.Task_Item_ID_2)) {
                this.story_model.curr_view_story_step = 3
                GlobalEventSystem.Fire(EventName.HIDE_FINGER, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2)
            }
            this.story_obj_list[TaskTipType.ActiveSoap] = [null, null, null, this.mosaicBox]
        }
        super.createChildren()
    }

    private RenderView() {
        this.soaps = this.monsterModel.GetShowSoapIds();
        // 默认选中有红点的古宝
        let redIndex: number = this.soaps.findIndex((id: number) => {
            return this.monsterModel.GetSoapRedDot(id);
        });

        if (redIndex == -1) {
            // 选中未激活的古宝
            this.curSoapIndex = this.soaps.findIndex((id: number) => {
                return !this.monsterModel.GetActBySoapId(id);
            });
        } else {
            this.curSoapIndex = redIndex;
        }
        this.curSoapId = this.soaps[Math.max(0, this.curSoapIndex)];
        this.SelectSoap(this.curSoapId);

    }

    /**
     * 展示选中的古宝
     * @param soapId 
     */
    private SelectSoap(soapId: number) {
        this.debrisIds = this.monsterModel.GetFragmentsAllBySoapId(this.curSoapId);
        let confSoap: ISConfSoap = this.monsterModel.GetSoapConfBySoapId(soapId);
        let confSoapDebris: ISConfSoapDebris = this.monsterModel.GetSoapConfBySoapIdAndDebrisId(soapId, 1); // 默认拿第一个
        this.nameLab.text = confSoap.soap_name;
        this.iconNameLab1.text = confSoap.soap_name;
        ResManager.GetInstance().SetImageSpriteTrans(this, this.stateImg, GameResPath.GetIcon('monster', this.monsterModel.GetActBySoapId(soapId) ? 'ui_zy_10' : 'ui_zy_09'));
        this.lImg.visible = this.curSoapIndex > 0;
        this.rImg.visible = this.curSoapIndex < this.soaps.length - 1;
        this.rRedImg.visible = this.rImg.visible && this.monsterModel.GetRightRedDot(this.curSoapIndex);
        this.lRedImg.visible = this.lImg.visible && this.monsterModel.GetLeftRedDot(this.curSoapIndex);

        if (this.modeId != confSoapDebris.model_id) {
            this.modeId = confSoapDebris.model_id;
            this.ShowModel(confSoapDebris.model_id);
        }

        this.RenderSoap();
        this.RenderIcon();
        this.SetSelectIndex();
    }

    /**
     * 渲染古宝
     */
    private RenderSoap() {
        this.RenderSoapAttr();
        this.jump1Box.visible = !this.monsterModel.GetActBySoapId(this.curSoapId);
    }

    /**
     * 渲染碎片
     */
    private RednerDebris() {
        let conf: ISConfSoapDebris = this.monsterModel.GetSoapConfBySoapIdAndDebrisId(this.curSoapId, this.curDebrisId);
        let cost = ErlangParser.GetInstance().parse(conf.cost)[0];
        let costNum: number = cost[2];
        let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(cost[1])
        let totalNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(cost[1]);
        let color: string = (totalNum >= costNum ? ("'#b3ff48'") : ("'#ff4f50'"));
        this.iconNameLab.text = conf.debris_name;
        this.attrNameLab.text = conf.debris_name + '属性';


        this.costHtml.innerHTML = Util.StrToHTML("<font color=" + color + ">" + totalNum + "</font>/" + costNum)
        this.costHtml.width = this.costHtml.contextWidth + 15;
        this.costHtml.height = this.costHtml.contextHeight + 5;

        if (!this.item2) {
            this.item2 = new BaseAwardItem(this.costBox);
            this.item2.SetItemSize(85, 85);
            this.item2.Load();
        }
        if (goods_vo) {
            this.item2.SetData(goods_vo.type_id);
        }


        let isAct: boolean = this.monsterModel.GetActByDebrisId(this.curSoapId, this.curDebrisId);
        let red: boolean = this.monsterModel.GetDebrisRedDot(this.curSoapId, this.curDebrisId);

        this.mosaicImg.visible = isAct;
        this.jumpBox.visible = !isAct && !red;
        this.mosaicBox.visible = !isAct && red;

        this.RenderDebrisAttr();
    }


    /**
     * 古宝属性
     */
    private RenderSoapAttr() {
        let attrs = this.monsterModel.GetAttrsBySoapId(this.curSoapId);

        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(
                this.attrsList,
                MonsterPropertyItemOne,
                attrs,
                LoopScrCon.Vertical,
            );
        } else {
            this.loop_mgr.replaceAll(attrs);
        }

    }

    /**
     * 碎片属性
     */
    private RenderDebrisAttr() {
        let conf: ISConfSoapDebris = this.monsterModel.GetSoapConfBySoapIdAndDebrisId(this.curSoapId, this.curDebrisId);
        let attrs = ErlangParser.GetInstance().parse(conf.attr);
        if (!this.loop_mgr1) {
            this.loop_mgr1 = new LoopScrowViewMgr();
            this.loop_mgr1.SetData(
                this.attrList,
                MonsterPropertyItemOne,
                attrs,
                LoopScrCon.Vertical,
            );
        } else {
            this.loop_mgr1.replaceAll(attrs);
        }

    }


    /**
     * 渲染icon
     */
    private RenderIcon() {

        for (const iterator of this.item1) {
            iterator.SetVisible(false);
        }

        if (this.debrisIds.length == 2) {
            this.iconBox1.pos(this.iconBox3.x, this.iconBox3.y);
            this.iconBox2.visible = false;
            this.iconBox3.visible = false;
        } else {
            this.iconBox1.pos(81, 0);
            this.iconBox2.visible = true;
            this.iconBox3.visible = true;
        }

        for (let i = 0; i < this.debrisIds.length; i++) {
            const id: number = this.debrisIds[i];
            let _gp: Laya.Node = this.iconBox.getChildAt(i)
            let _item: MonsterIconItem = this.item1[i];
            if (!_item) {
                _item = new MonsterIconItem(_gp);
                _item.Load();
                table.insert(this.item1, _item);
            }
            _item.SetVisible(true);
            _item.SetData(id, this.curSoapId, i);
        }
    }

    /**
     * 展示模型
     */
    private ShowModel(model_id: string) {
        this.ClearModel();
        model_id = ErlangParser.GetInstance().parse(model_id);
        CustomActivityModel.GetInstance().ShowViewModel(
            this,
            this.layout_file,
            model_id,
            this.modelBox,
            null,
            null,
            null,
            null,
        );
    }

    private ClickRight() {
        let index: number = this.curSoapIndex + 1;
        if (index <= this.soaps.length - 1) {
            this.curSoapIndex = index;
            this.curSoapId = this.soaps[this.curSoapIndex];
            this.SelectSoap(this.curSoapId);
        }
    }

    private ClickLeft() {
        let index: number = this.curSoapIndex - 1;
        if (index >= 0) {
            this.curSoapIndex = index;
            this.curSoapId = this.soaps[this.curSoapIndex];
            this.SelectSoap(this.curSoapId);
        }
    }

    private SetSelectIndex() {
        let redIndex: number = this.debrisIds.findIndex((id: number) => {
            return this.monsterModel.GetDebrisRedDot(this.curSoapId, id);
        });

        if (redIndex != -1) {
            this.SelectIcon(redIndex);
        } else {
            this.ClearSelect();
            this.ShowOrHideDebrisBox(false);
            /*  let outBounds: boolean = this.curDebrisIndex > this.debrisIds.length - 1;
             if (outBounds) {
                 let mosterParam: IS2CMosterParam = this.monsterModel.GetSoapsBySoapIdMap(this.curSoapId);
                 let ids: { debris_id: number }[] = mosterParam?.debris_list || [];
                 let flag: boolean = false;
                 for (let i = 0; i < this.debrisIds.length; i++) {
                     const id: number = this.debrisIds[i];
                     let index: number = ids?.findIndex((item: { debris_id: number }) => {
                         return item.debris_id == id;
                     });
                     if (index == -1) {
                         this.SelectIcon(i);
                         flag = true;
                     }
                 }
 
                 if (!flag) {
                     this.SelectIcon(this.debrisIds.length - 1);
                 }
 
             } else {
                 this.SelectIcon(Math.max(0, this.curDebrisIndex));
             } */
        }

    }

    /**
     * 选中碎片
     */
    private SelectIcon(index: number) {
        for (let i = 0; i < this.item1.length; i++) {
            const item: MonsterIconItem = this.item1[i];
            if (index == i) {
                this.monsterModel.Fire(MonsterModelEvent.SELECT_INDEX, index);
                this.curDebrisId = this.debrisIds[index];
                this.RednerDebris();
            }
        }
        this.ShowOrHideDebrisBox(true);

    }

    private ClearSelect() {
        for (const iterator of this.item1) {
            iterator.SelectIcon(-1);
        }
    }

    private ClearModel() {
        ResManager.GetInstance().ClearRoleMode(this.$hashCode);
    }


    private ShowOrHideDebrisBox(show: boolean) {

        Laya.Tween.clearAll(this.fragmentsBox);
        if (show) {
            this.fragmentsBox.visible = true;
            Laya.Tween.to(this.fragmentsBox, { y: this.initY, alpha: 1 }, 200, undefined, Laya.Handler.create(this, () => {
                this.totalBox.visible = false;
            }))
        } else {
            this.ClearSelect();
            this.totalBox.visible = true;
            Laya.Tween.to(this.fragmentsBox, { y: this.hideY, alpha: 0 }, 200, undefined, Laya.Handler.create(this, () => {
                this.fragmentsBox.visible = false;
            }));
        }
    }





    public DeleteMe() {
        if (this.item1) {
            for (let key in this.item1) {
                let _item = this.item1[key];
                _item.DeleteMe();
            }
            this.item1 = [];
        }

        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe();
            this.loop_mgr = null;
        }

        if (this.loop_mgr1) {
            this.loop_mgr1.DeleteMe();
            this.loop_mgr1 = null;
        }

        if (this.item2) {
            this.item2.DeleteMe();
            this.item2 = null;
        }

        if (this.fightNum) {
            this.fightNum.DeleteMe()
            this.fightNum = null
        }

        super.DeleteMe();
    }


    imgBg1: Laya.Image
    nameLab: Laya.Label
    combatBox: Laya.Box
    modelBox: Laya.Box
    iconBox: Laya.Box
    iconBox0: Laya.Box
    iconBox1: Laya.Box
    iconBox2: Laya.Box
    iconBox3: Laya.Box
    stateImg: Laya.Image
    lImg: Laya.Image
    lRedImg: Laya.Image
    rImg: Laya.Image
    rRedImg: Laya.Image
    attrImg: Laya.Image
    totalBox: Laya.Box
    iconNameLab1: Laya.Label
    imgBg3: Laya.Image
    mosaicImg1: Laya.Image
    attrsList: Laya.List
    jump1Box: Laya.Box
    fragmentsBox: Laya.Box
    returnImg: Laya.Image
    iconNameLab: Laya.Label
    attrNameLab: Laya.Label
    imgBg2: Laya.Image
    mosaicImg: Laya.Image
    lineImg: Laya.Image
    attrList: Laya.List
    costBox: Laya.Box
    costHtml: Laya.HTMLDivElement
    jumpBox: Laya.Box
    mosaicBox: Laya.Box
    public GetComponents() {
        [
            this.imgBg1,
            this.nameLab,
            this.combatBox,
            this.modelBox,
            this.iconBox,
            this.iconBox0,
            this.iconBox1,
            this.iconBox2,
            this.iconBox3,
            this.stateImg,
            this.lImg,
            this.lRedImg,
            this.rImg,
            this.rRedImg,
            this.attrImg,
            this.totalBox,
            this.iconNameLab1,
            this.imgBg3,
            this.mosaicImg1,
            this.attrsList,
            this.jump1Box,
            this.fragmentsBox,
            this.returnImg,
            this.iconNameLab,
            this.attrNameLab,
            this.imgBg2,
            this.mosaicImg,
            this.lineImg,
            this.attrList,
            this.costBox,
            this.costHtml,
            this.jumpBox,
            this.mosaicBox,
        ]
            = this.GetChildrenByNames([

                "imgBg1",
                "nameLab",
                "combatBox",
                "modelBox",
                "iconBox",
                "iconBox0",
                "iconBox1",
                "iconBox2",
                "iconBox3",
                "stateImg",
                "lImg",
                "lRedImg",
                "rImg",
                "rRedImg",
                "attrImg",
                "totalBox",
                "iconNameLab1",
                "imgBg3",
                "mosaicImg1",
                "attrsList",
                "jump1Box",
                "fragmentsBox",
                "returnImg",
                "iconNameLab",
                "attrNameLab",
                "imgBg2",
                "mosaicImg",
                "lineImg",
                "attrList",
                "costBox",
                "costHtml",
                "jumpBox",
                "mosaicBox",
            ])
    }
}
window["MonsterMainView"] = MonsterMainView