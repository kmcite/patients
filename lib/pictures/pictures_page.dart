import 'package:patients/main.dart';

import 'pictures_bloc.dart';

class PicturesPage extends UI {
  const PicturesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // leading: FloatingActionButton(
          //   onPressed: () => FilePicker.platform.pickFiles().then(
          //     (filePickerResult) {
          //       if (filePickerResult != null) {
          //         final path = filePickerResult.files.first.path;
          //         if (path != null) {
          //           picturesBloc.put(Picture()..path = path);
          //         }
          //       }
          //     },
          //   ),
          //   child: Icon(Icons.add_a_photo),
          // ).pad(),
          // actions: [
          //   const BackButton().pad(),
          // ],
          ),
      body: ListView(
        children: picturesBloc.pictures.map(
          (picture) {
            return ListTile(
              leading: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(settings().borderRadius),
                ),
                child: Image.file(
                  File(picture.path),
                  fit: BoxFit.contain,
                ),
              ),
              title: picture.path.text(),
              trailing: IconButton(
                onPressed: () => picturesBloc.remove(picture.id),
                icon: Icon(Icons.delete_forever),
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
