/****************************************************************************
** Meta object code from reading C++ file 'GMTools.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.11.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../GMTools.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'GMTools.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.11.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_GMTools_t {
    QByteArrayData data[16];
    char stringdata0[134];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_GMTools_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_GMTools_t qt_meta_stringdata_GMTools = {
    {
QT_MOC_LITERAL(0, 0, 7), // "GMTools"
QT_MOC_LITERAL(1, 8, 4), // "step"
QT_MOC_LITERAL(2, 13, 0), // ""
QT_MOC_LITERAL(3, 14, 12), // "on_logingame"
QT_MOC_LITERAL(4, 27, 10), // "on_sendcmd"
QT_MOC_LITERAL(5, 38, 8), // "on_reset"
QT_MOC_LITERAL(6, 47, 9), // "write_log"
QT_MOC_LITERAL(7, 57, 11), // "std::string"
QT_MOC_LITERAL(8, 69, 3), // "txt"
QT_MOC_LITERAL(9, 73, 8), // "auto_set"
QT_MOC_LITERAL(10, 82, 6), // "on_msg"
QT_MOC_LITERAL(11, 89, 9), // "msg_base&"
QT_MOC_LITERAL(12, 99, 3), // "msg"
QT_MOC_LITERAL(13, 103, 9), // "on_accmsg"
QT_MOC_LITERAL(14, 113, 9), // "on_chnmsg"
QT_MOC_LITERAL(15, 123, 10) // "on_gamemsg"

    },
    "GMTools\0step\0\0on_logingame\0on_sendcmd\0"
    "on_reset\0write_log\0std::string\0txt\0"
    "auto_set\0on_msg\0msg_base&\0msg\0on_accmsg\0"
    "on_chnmsg\0on_gamemsg"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_GMTools[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
      10,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: name, argc, parameters, tag, flags
       1,    0,   64,    2, 0x0a /* Public */,
       3,    0,   65,    2, 0x0a /* Public */,
       4,    0,   66,    2, 0x0a /* Public */,
       5,    0,   67,    2, 0x0a /* Public */,
       6,    1,   68,    2, 0x0a /* Public */,
       9,    0,   71,    2, 0x0a /* Public */,
      10,    1,   72,    2, 0x0a /* Public */,
      13,    1,   75,    2, 0x0a /* Public */,
      14,    1,   78,    2, 0x0a /* Public */,
      15,    1,   81,    2, 0x0a /* Public */,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 7,    8,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 11,   12,
    QMetaType::Void, 0x80000000 | 11,   12,
    QMetaType::Void, 0x80000000 | 11,   12,
    QMetaType::Void, 0x80000000 | 11,   12,

       0        // eod
};

void GMTools::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        GMTools *_t = static_cast<GMTools *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->step(); break;
        case 1: _t->on_logingame(); break;
        case 2: _t->on_sendcmd(); break;
        case 3: _t->on_reset(); break;
        case 4: _t->write_log((*reinterpret_cast< std::string(*)>(_a[1]))); break;
        case 5: _t->auto_set(); break;
        case 6: _t->on_msg((*reinterpret_cast< msg_base(*)>(_a[1]))); break;
        case 7: _t->on_accmsg((*reinterpret_cast< msg_base(*)>(_a[1]))); break;
        case 8: _t->on_chnmsg((*reinterpret_cast< msg_base(*)>(_a[1]))); break;
        case 9: _t->on_gamemsg((*reinterpret_cast< msg_base(*)>(_a[1]))); break;
        default: ;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject GMTools::staticMetaObject = {
    { &QDialog::staticMetaObject, qt_meta_stringdata_GMTools.data,
      qt_meta_data_GMTools,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *GMTools::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *GMTools::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_GMTools.stringdata0))
        return static_cast<void*>(this);
    return QDialog::qt_metacast(_clname);
}

int GMTools::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QDialog::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 10)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 10;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 10)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 10;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
