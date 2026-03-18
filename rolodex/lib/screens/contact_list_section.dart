import 'package:flutter/cupertino.dart';
import 'package:rolodex/data/contact.dart';

class ContactListSection extends StatelessWidget {
  const ContactListSection({
    super.key,
    required this.lastInitial,
    required this.contacts,
  });

  final String lastInitial;
  final List<Contact> contacts;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            lastInitial,
            style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
          ),
        ),
        ...contacts.map((contact) => _buildContactTile(contact, context)),
      ],
    );
  }

  Widget _buildContactTile(Contact contact, BuildContext context) {
    return CupertinoListTile(
      title: Text('${contact.firstName} ${contact.lastName}'),
      subtitle: _buildSubtitle(contact),
      leading: _buildAvatar(contact),
      onTap: () {
        // TODO: Implement contact detail view
        debugPrint('Tapped on ${contact.firstName} ${contact.lastName}');
      },
    );
  }

  // Reemplazamos CircleAvatar con un widget estilo iOS
  Widget _buildAvatar(Contact contact) {
    final String initials = '${contact.firstName[0]}${contact.lastName[0]}';
    
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey5,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontSize: 14, 
            fontWeight: FontWeight.w500,
            color: CupertinoColors.label,
          ),
        ),
      ),
    );
  }

  Widget? _buildSubtitle(Contact contact) {
    if (contact.middleName == null && contact.suffix == null) {
      return null;
    }
    
    final List<String> parts = [];
    if (contact.middleName != null) {
      parts.add(contact.middleName!);
    }
    if (contact.suffix != null) {
      parts.add(contact.suffix!);
    }
    
    return Text(parts.join(' • '));
  }
}