import { BaseView1 } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { LoopScrCon, LoopScrowViewMgr } from '../common/LoopScrowViewMgr';
import { LuaSoundManager } from '../common/SoundManager';
import { GuildModel, GuildEvent } from '../commonModel/GuildModel';
import { Util } from '../util/Util';
import { GuildApplyLookItem } from './GuildApplyLookItem';

export class GuildApplyLookView extends BaseView1 {
    use_background = true;
    click_bg_toClose = true;
    is_center = true;
    show_open_movie = true;
    destroy_imm = true;
    destroy_callback;
    loop_mgr: LoopScrowViewMgr;
    list: ProtoRecvVObj<40008>['apply_list'];
    model: GuildModel;
    public constructor() {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildApplyLookView';
        this.layer_value = Enum_UILayer.Activity;
        this.model = GuildModel.GetInstance();
        this.destroy_callback = () => {
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe();
                this.loop_mgr = null;
            }
        };

        this.load_callback = () => {
            this.InitEvent();
            this.UpdateView();
        };
    }

    InitEvent() {
        Util.AddClickEvent(
            this._btn_pass,
            () => {
                this.model.Fire(GuildEvent.REQUEST_PROTO, 40016, 'c', 1);
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_refuse,
            () => {
                this.model.Fire(GuildEvent.REQUEST_PROTO, 40016, 'c', 2);
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._Image1,
            () => {
                this.Close();
            },
            this,
            true,
            null,
            null,
            null,
            null,
            LuaSoundManager.SOUND_UI.CLOSE
        );
        this.BindVar(this.model, 'apply_info', () => {
            this.UpdateView();
        });
    }

    UpdateView() {
        let apply_info = this.model.GetApplyInfo();
        this.list = apply_info.apply_list;

        //let next_collect = eui. new ArrayCollection(list)
        //this._group_data.dataProvider = next_collect
        //this._group_data.itemRenderer = GuildApplyLookItem

        if (!this.loop_mgr) {
            this.loop_mgr = new LoopScrowViewMgr();
            this.loop_mgr.SetData(this._list_items, GuildApplyLookItem, this.list, LoopScrCon.Vertical);
        } else {
            this.loop_mgr.replaceAll(this.list);
        }

        this._group_empty.visible = this.list.length <= 0;
    }

    _Image11: Laya.Image;
    _btn_pass: Laya.Box;
    _Image1111: Laya.Image;
    labelDisplay: Laya.Label;
    _btn_refuse: Laya.Box;
    _Image111: Laya.Image;
    labelDisplay1: Laya.Label;
    _Image3: Laya.Image;
    _list_items: Laya.List;
    _Image1: Laya.Image;
    _group_empty: Laya.Box;
    _Image7: Laya.Image;
    _Label2: Laya.Label;
    _Image2_title: Laya.Image;
    _lb_win_name: Laya.Label;
    public GetComponents() {
        [this._Image11, this._btn_pass, this._Image1111, this.labelDisplay, this._btn_refuse, this._Image111, this.labelDisplay1, this._Image3, this._list_items, this._Image1, this._group_empty, this._Image7, this._Label2, this._Image2_title, this._lb_win_name] = this.GetChildrenByNames(['_Image11', '_btn_pass', '_Image1111', 'labelDisplay', '_btn_refuse', '_Image111', 'labelDisplay1', '_Image3', '_list_items', '_Image1', '_group_empty', '_Image7', '_Label2', '_Image2_title', '_lb_win_name']);
    }
}
window['GuildApplyLookView'] = GuildApplyLookView;
