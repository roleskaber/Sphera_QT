#include "musiccatalog.h"

MusicCatalog::MusicCatalog(QObject *parent)
    : QAbstractItemModel(parent)
{}

QVariant MusicCatalog::headerData(int section, Qt::Orientation orientation, int role) const
{
    // FIXME: Implement me!
}

QModelIndex MusicCatalog::index(int row, int column, const QModelIndex &parent) const
{
    // FIXME: Implement me!
}

QModelIndex MusicCatalog::parent(const QModelIndex &index) const
{
    // FIXME: Implement me!
}

int MusicCatalog::rowCount(const QModelIndex &parent) const
{
    if (!parent.isValid())
        return 0;

    // FIXME: Implement me!
}

int MusicCatalog::columnCount(const QModelIndex &parent) const
{
    if (!parent.isValid())
        return 0;

    // FIXME: Implement me!
}

QVariant MusicCatalog::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    // FIXME: Implement me!
    return QVariant();
}
