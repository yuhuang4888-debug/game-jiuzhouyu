import { Alert, Alert_Type } from '../alert/Alert';
import { BaseView1 } from '../common/BaseView1';
import { Enum_UILayer } from '../common/LayerManager';
import { FriendEvent, FriendModel } from '../commonModel/FriendModel';
import { GuildModel, GuildEvent, GuildPermission } from '../commonModel/GuildModel';
import { Enum_ColorUtil_Dark } from '../util/ColorUtil';
import { SetSizeDeltaY, Util, HtmlColorTxt } from '../util/Util';

export class GuildRoleMenuView extends BaseView1 {
    show_open_movie = true;
    click_bg_toClose = true;
    use_background = true;
    background_alpha = 0;
    cache_x;
    cache_y;
    x;
    y;
    role_data;
    model: GuildModel;
    friendModel: FriendModel;
    public constructor() {
        super();

        this.base_file = 'guild';
        this.layout_file = 'GuildRoleMenuView';
        this.layer_value = Enum_UILayer.Activity;
        this.model = GuildModel.GetInstance();
        this.friendModel = FriendModel.GetInstance();
        this.load_callback = () => {
            this._scroller.vScrollBarSkin = '';

            this.InitEvent();
        };

        this.open_callback = () => {
            this.InitView();
            this.display_obj.x = this.cache_x;
            this.display_obj.y = this.cache_y;
            this.LayoutContent(this.Content);
        };
    }

    public DeleteMe() {
        super.DeleteMe();
    }

    public Open(...new_args) {
        this.role_data = new_args[0][0];
        this.cache_x = new_args[0][1];
        this.cache_y = new_args[0][2];
        super.Open();
    }

    InitView() {
        let can_change_pos = this.model.HasPermission(GuildPermission.APPOINT_POS);
        this._btn_master.visible = can_change_pos;
        //this._btn_master.includeInLayout = this._btn_master.visible
        let is_sec = this.role_data.position == 2;
        this._btn_sec.visible = can_change_pos && !is_sec;
        //this._btn_sec.includeInLayout = this._btn_sec.visible
        this._btn_secdown.visible = can_change_pos && is_sec;
        //this._btn_secdown.includeInLayout = this._btn_secdown.visible
        let compare = GuildModel.ComparePosition(this.role_data.position);
        this._btn_out.visible = this.model.HasPermission(GuildPermission.FIRE_MEMBER); //&& compare
        //this._btn_out.includeInLayout = this._btn_out.visible
        let is_baby = this.role_data.position == 4;
        this._btn_baby.visible = can_change_pos && !is_baby;
        //this._btn_baby.includeInLayout = this._btn_baby.visible
        this._btn_babydown.visible = can_change_pos && is_baby;
        //this._btn_babydown.includeInLayout = this._btn_babydown.visible
        let is_cadre = this.role_data.position == 5;
        this._btn_cadre.visible = can_change_pos && !is_cadre;
        //this._btn_cadre.includeInLayout = this._btn_cadre.visible
        this._btn_cadredown.visible = can_change_pos && is_cadre;
        //this._btn_cadredown.includeInLayout = this._btn_cadredown.visible
        let fdata = this.friendModel.getFriendById(this.role_data.role_id);

        this._btn_friend.visible = !fdata;
        //this._btn_friend.includeInLayout = ! fdata
        this._btn_delFri.visible = fdata;
        //this._btn_delFri.includeInLayout = ! (not fdata)
        this._btn_chat.visible = fdata;
        //this._btn_chat.includeInLayout = ! (not fdata)
        let count = 0;
        let i = 0;
        let child: any;
        do {
            child = this.Content.getChildAt(i);
            // [ts2lua]lua中0和空字符串也是true，此处child.visible需要确认
            count = count + ((child.visible && 1) || 0);
            i = i + 1;
        } while (i < 13);

        //let height = ((count >= 5) && (310) || ((count <= 2 && { 138} || { count * 61 + 16))})[1]
        //this.display_obj.height = count >= 5 ? 310 : (count <= 2 ? 138 : count * 61 + 16 - 11)
        let splace = 25;
        let temp_h = count >= 5 ? 330 : count * 67 + splace; //65+2
        this.display_obj.height = temp_h;

        SetSizeDeltaY(this._scroller, temp_h - splace);
        SetSizeDeltaY(this.Content, temp_h - splace);
    }

    ClickThis(e?) {
        //e:stopImmediatePropagation()
        //if (! _scroll_mark && e.target.instanceof(Laya.Button) ) {
        //e.target.dispatchEventWith(Laya.TouchEvent.TOUCH_TAP, false, e)
        // }
    }

    InitEvent() {
        //this:BindEvent(GlobalEventSystem, EventName.STAGE_CLICK_EVENT,() => {
        //this:Close()
        //}
        //)

        this.BindEvent(this.model, GuildEvent.CLOSE_ROLE_MENU_VIEW, () => {
            this.Close();
        });

        //this._scroller.addEventListener(local_UIEvent.CHANGE_END,() => {
        //_scroll_mark = false
        //}
        //, this)
        //this._scroller.addEventListener(local_UIEvent.CHANGE_START,() => {
        //_scroll_mark = true
        //}
        //, this)

        //this:addEventListener(Laya.TouchEvent.TOUCH_TAP, this.ClickThis, this, true, 1)

        Util.AddClickEvent(
            this._btn_msg,
            () => {
                this.friendModel.requestPlayerMessage(this.role_data.role_id);
                this.Close();
            },
            this,
            true
        );

        Util.AddClickEvent(
            this._btn_sec,
            () => {
                let name = HtmlColorTxt('[' + this.role_data.name + ']', Enum_ColorUtil_Dark.GREEN);
                let str = Util.StrToHTML('是否确定将' + name + '提升为副会长？');
                Alert.Show(str, Alert_Type.Two, () => {
                    this.model.Fire(GuildEvent.REQUEST_PROTO, 40013, 'lc', this.role_data.role_id, 2);
                    this.Close();
                });
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_master,
            () => {
                let name = HtmlColorTxt('[' + this.role_data.name + ']', Enum_ColorUtil_Dark.GREEN);
                let str = Util.StrToHTML('是否确定将' + name + '提升为会长？');
                Alert.Show(str, Alert_Type.Two, () => {
                    this.model.Fire(GuildEvent.REQUEST_PROTO, 40013, 'lc', this.role_data.role_id, 1);
                    this.Close();
                });
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_friend,
            () => {
                this.friendModel.Fire(FriendEvent.ADD_FRIEND, this.role_data.role_id);
                this.Close();
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_delFri,
            () => {
                this.friendModel.Fire(FriendEvent.FRIENDS_OPERATIONT, 1, this.role_data.role_id);
                this.Close();
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_black,
            () => {
                this.friendModel.Fire(FriendEvent.FRIENDS_OPERATIONT, 2, this.role_data.role_id);
                this.Close();
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_out,
            () => {
                let name = HtmlColorTxt('[' + this.role_data.name + ']', Enum_ColorUtil_Dark.GREEN);
                let str = Util.StrToHTML('是否确定' + name + '将踢出结社？');
                Alert.Show(str, Alert_Type.Two, () => {
                    this.model.Fire(GuildEvent.REQUEST_PROTO, 40014, 'l', this.role_data.role_id);
                    this.Close();
                });
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_secdown,
            () => {
                Alert.Show('是否确认撤销副会长？', Alert_Type.Two, () => {
                    this.model.Fire(GuildEvent.REQUEST_PROTO, 40013, 'lc', this.role_data.role_id, 3);
                    this.Close();
                });
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_baby,
            () => {
                let name = HtmlColorTxt('[' + this.role_data.name + ']', Enum_ColorUtil_Dark.GREEN);
                let str = Util.StrToHTML('是否确定将' + name + '提升为宝贝？');
                Alert.Show(str, Alert_Type.Two, () => {
                    this.model.Fire(GuildEvent.REQUEST_PROTO, 40013, 'lc', this.role_data.role_id, 4);
                    this.Close();
                });
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_cadre,
            () => {
                let name = HtmlColorTxt('[' + this.role_data.name + ']', Enum_ColorUtil_Dark.GREEN);
                let str = Util.StrToHTML('是否确定将' + name + '提升为精英？');
                Alert.Show(str, Alert_Type.Two, () => {
                    this.model.Fire(GuildEvent.REQUEST_PROTO, 40013, 'lc', this.role_data.role_id, 5);
                    this.Close();
                });
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_babydown,
            () => {
                let str = Util.StrToHTML('是否确认撤销宝贝？');
                Alert.Show(str, Alert_Type.Two, () => {
                    this.model.Fire(GuildEvent.REQUEST_PROTO, 40013, 'lc', this.role_data.role_id, 3);
                    this.Close();
                });
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_cadredown,
            () => {
                let str = Util.StrToHTML('是否确认撤销精英？');
                Alert.Show(str, Alert_Type.Two, () => {
                    this.model.Fire(GuildEvent.REQUEST_PROTO, 40013, 'lc', this.role_data.role_id, 3);
                    this.Close();
                });
            },
            this,
            true
        );
        Util.AddClickEvent(
            this._btn_chat,
            () => {
                let fdata = this.friendModel.getFriendById(this.role_data.role_id);
                if (fdata) {
                    this.friendModel.Fire(FriendEvent.OPEN_CHAT_VIEW, fdata);
                }
            },
            this,
            true
        );
    }

    LayoutContent(box: Laya.Box) {
        let len = box.numChildren;
        let cell: any;
        let space_y = 2;
        let cur_x = 2;
        for (let i = 0; i < len; i++) {
            cell = box.getChildAt(i);
            if (cell.visible) {
                cell.y = cur_x;
                cur_x += cell.height + space_y;
            }
        }
        this.Content.height = cur_x;
        this._scroller.vScrollBar.value = 0;
    }

    _img_bg: Laya.Image;
    _scroller: Laya.Panel;
    Content: Laya.Box;
    _btn_msg: Laya.Box;
    _Image111111111111: Laya.Image;
    labelDisplay111111111111: Laya.Label;
    _btn_master: Laya.Box;
    _Image11: Laya.Image;
    labelDisplay11111: Laya.Label;
    _btn_sec: Laya.Box;
    _Image11111: Laya.Image;
    labelDisplay111: Laya.Label;
    _btn_baby: Laya.Box;
    _Image111: Laya.Image;
    labelDisplay11: Laya.Label;
    _btn_cadre: Laya.Box;
    _Image11111111111: Laya.Image;
    labelDisplay1111111111: Laya.Label;
    _btn_secdown: Laya.Box;
    _Image11111111: Laya.Image;
    labelDisplay11111111111: Laya.Label;
    _btn_babydown: Laya.Box;
    _Image1111111111111: Laya.Image;
    labelDisplay111111111: Laya.Label;
    _btn_cadredown: Laya.Box;
    _Image1111111: Laya.Image;
    labelDisplay1111111: Laya.Label;
    _btn_chat: Laya.Box;
    _Image1: Laya.Image;
    labelDisplay: Laya.Label;
    _btn_friend: Laya.Box;
    _Image1111: Laya.Image;
    labelDisplay11111111: Laya.Label;
    _btn_delFri: Laya.Box;
    _Image1111111111: Laya.Image;
    labelDisplay1: Laya.Label;
    _btn_black: Laya.Box;
    _Image111111: Laya.Image;
    labelDisplay1111: Laya.Label;
    _btn_out: Laya.Box;
    _Image111111111: Laya.Image;
    labelDisplay111111: Laya.Label;
    public GetComponents() {
        [this._img_bg, this._scroller, this.Content, this._btn_msg, this._Image111111111111, this.labelDisplay111111111111, this._btn_master, this._Image11, this.labelDisplay11111, this._btn_sec, this._Image11111, this.labelDisplay111, this._btn_baby, this._Image111, this.labelDisplay11, this._btn_cadre, this._Image11111111111, this.labelDisplay1111111111, this._btn_secdown, this._Image11111111, this.labelDisplay11111111111, this._btn_babydown, this._Image1111111111111, this.labelDisplay111111111, this._btn_cadredown, this._Image1111111, this.labelDisplay1111111, this._btn_chat, this._Image1, this.labelDisplay, this._btn_friend, this._Image1111, this.labelDisplay11111111, this._btn_delFri, this._Image1111111111, this.labelDisplay1, this._btn_black, this._Image111111, this.labelDisplay1111, this._btn_out, this._Image111111111, this.labelDisplay111111] = this.GetChildrenByNames([
            '_img_bg',
            '_scroller',
            'Content',
            '_btn_msg',
            '_Image111111111111',
            'labelDisplay111111111111',
            '_btn_master',
            '_Image11',
            'labelDisplay11111',
            '_btn_sec',
            '_Image11111',
            'labelDisplay111',
            '_btn_baby',
            '_Image111',
            'labelDisplay11',
            '_btn_cadre',
            '_Image11111111111',
            'labelDisplay1111111111',
            '_btn_secdown',
            '_Image11111111',
            'labelDisplay11111111111',
            '_btn_babydown',
            '_Image1111111111111',
            'labelDisplay111111111',
            '_btn_cadredown',
            '_Image1111111',
            'labelDisplay1111111',
            '_btn_chat',
            '_Image1',
            'labelDisplay',
            '_btn_friend',
            '_Image1111',
            'labelDisplay11111111',
            '_btn_delFri',
            '_Image1111111111',
            'labelDisplay1',
            '_btn_black',
            '_Image111111',
            'labelDisplay1111',
            '_btn_out',
            '_Image111111111',
            'labelDisplay111111'
        ]);
    }
}
window['GuildRoleMenuView'] = GuildRoleMenuView;
