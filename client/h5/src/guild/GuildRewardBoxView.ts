import { BaseItem1 } from '../common/BaseItem1';
import { EventName } from '../common/EventName';
import { InstructionType } from '../common/InstructionType';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { ResManager } from '../common/ResManager';
import { table } from '../common/table';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { GlobalEventSystem } from '../util/DeclareGlobalVar';
import { GameResPath } from '../util/GameResPath';
import { Util } from '../util/Util';
import { GuildRBItem } from './GuildRBItem';
import { GuildRBRecordItem } from './GuildRBRecordItem';

export class GuildRewardBoxView extends BaseItem1 {
    _box_ac: LoopScrowViewMgr;
    _record_ac: LoopScrowViewMgr;
    _model: GuildModel;

    public constructor(parent?) {
        super(parent);

        this.base_file = 'guild';
        this.layout_file = 'GuildRewardBoxView';
        this._model = GuildModel.GetInstance();
        this.preload_server_config = { config_guild_daily: false };
        this.load_callback = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_null1, GameResPath.GetIcon('guild', 'mainui_message2'));
            this.InitEvent();
            this.LoadSuccess();
        };
    }

    public DeleteMe() {
        if (this._box_ac) {
            this._box_ac.DeleteMe();
            this._box_ac = null;
        }
        if (this._record_ac) {
            this._record_ac.DeleteMe();
            this._record_ac = null;
        }
        super.DeleteMe();
    }

    InitEvent() {
        Util.AddClickEvent(
            this._btn_send,
            () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, 'GuildRBSendView');
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_get,
            () => {
                this._model.Fire(GuildEvent.REQUEST_PROTO, 40302, 'l', 0);
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._instruction,
            () => {
                GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.Reward_box);
            },
            this,
            true
        );
        this.BindEvent(this._model, GuildEvent.REWARD_BOX_DATA_UPDATE, () => {
            this.updateRecord();
            this.updateBox();
            this.updateDesc();
        });
    }

    updateRecord() {
        let data = this._model._rewardBoxViewData.log;
        if (!this._record_ac) {
            this._record_ac = new LoopScrowViewMgr();
            this._record_ac.SetData(this._list_content, GuildRBRecordItem, data, LoopScrCon.Vertical);
        } else {
            this._record_ac.replaceAll(data);
        }
    }

    updateBox() {
        let data = this._model._rewardBoxViewData.send_list;

        table.sort(data, (a?, b?) => {
            let aIndex = 10;
            let bIndex = 10;
            if (a.status == 1) {
                aIndex = aIndex - 2;
            }
            if (b.status == 1) {
                bIndex = bIndex - 2;
            }
            if (a.time != b.time) {
                if (a.time > b.time) {
                    aIndex = aIndex - 1;
                } else {
                    bIndex = bIndex - 1;
                }
            }
            return bIndex < aIndex;
        });

        if (data.length > 0) {
            this._gp_null.visible = false;
            this._list_item.visible = true;
            if (!this._box_ac) {
                this._box_ac = new LoopScrowViewMgr();
                this._box_ac.SetData(this._list_item, GuildRBItem, data, LoopScrCon.Vertical);

                //this._box_ac = eui. new ArrayCollection(data)
                //this._box_list.dataProvider = this._box_ac
                //this._box_list.itemRenderer = GuildRBItem
            } else {
                //if (data.length <= 0 ) {
                //this._box_ac.source = data
                //}else{
                this._box_ac.replaceAll(data);
                //}
            }
        } else {
            this._gp_null.visible = true;
            this._list_item.visible = false;
        }
    }

    updateDesc() {
        let now = this._model._rewardBoxViewData.num;
        let max = this._model._rewardBoxViewData.max_num;
        this._Label2.text = '今日可领取宝箱：';
        this._lb_next_attr.text = `${now}/${max}`; //Util.StrToHTML("今日可领取宝箱：<font color=\"#639c12\">" + now + "/" + max + "</font>")
        this._red_dot.visible = this._model.rewardBoxRed();
    }

    LoadSuccess() {
        this._model.Fire(GuildEvent.REQUEST_PROTO, 40301);
    }

    _Image111: Laya.Image;
    _Image2: Laya.Image;
    _Group1: Laya.Box;
    _list_content: Laya.List;
    _gp_null: Laya.Box;
    _img_null1: Laya.Image;
    _Label1: Laya.Label;
    _list_item: Laya.List;
    _btn_send: Laya.Box;
    _Image1: Laya.Image;
    labelDisplay: Laya.Label;
    _btn_get: Laya.Box;
    _Image11: Laya.Image;
    labelDisplay1: Laya.Label;
    _red_dot: Laya.Image;
    _instruction: Laya.Image;
    _img_jiejie_b: Laya.Image;
    _group_attr_next: Laya.HBox;
    _Label2: Laya.Label;
    _lb_next_attr: Laya.Label;
    public GetComponents() {
        [this._Image111, this._Image2, this._Group1, this._list_content, this._gp_null, this._img_null1, this._Label1, this._list_item, this._btn_send, this._Image1, this.labelDisplay, this._btn_get, this._Image11, this.labelDisplay1, this._red_dot, this._instruction, this._img_jiejie_b, this._group_attr_next, this._Label2, this._lb_next_attr] = this.GetChildrenByNames(['_Image111', '_Image2', '_Group1', '_list_content', '_gp_null', '_img_null1', '_Label1', '_list_item', '_btn_send', '_Image1', 'labelDisplay', '_btn_get', '_Image11', 'labelDisplay1', '_red_dot', '_instruction', '_img_jiejie_b', '_group_attr_next', '_Label2', '_lb_next_attr']);
    }
}
window['GuildRewardBoxView'] = GuildRewardBoxView;
